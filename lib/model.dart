import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:solex/data.dart';
import 'package:crypto/crypto.dart';

class ItemBrain {
  static const String id = 'Item';
  final String load;
  final int qty;
  final int unitPower;
  late int totalPower;
  int dailyUsage;
  late int dailyEnergy;
//
  ItemBrain({required this.load, this.qty = 1, required this.unitPower, this.dailyUsage = 4});

  factory ItemBrain.fromJson(Map<dynamic, dynamic> passedJson) {
    return ItemBrain(load: passedJson['name'], unitPower: passedJson['watt']);
  }

  @override
  String toString() {
    return '{$load, $unitPower, $qty}';
  }

  late Battery _sB3;
  late int _totalPvPower;
  late int _totalPvNumbers;
  late Panel _selectedPanel;
  late Battery selectedB3;
  late int chargeController;
  late int inverterSize;

  // calculate for totalPower
  int calculateTP() {
    totalPower = qty * unitPower;
    return totalPower;
  }

  // calculate dailyEnergy
  int calculateDE() {
    dailyEnergy = calculateTP() * dailyUsage;
    return dailyEnergy;
  }

  // STEEPS 1
//SOLVE FOR SYSTEM VOLTAGE . FORMULAR = DE/1000
  int calculateV() {
    int volt = 12;
    var result = calculateDE() / 1000;
    // round result to int
    var newR = result.round();
    if (newR <= 2) {
      volt = 12;
    } else if (newR > 1 && newR <= 4) {
      volt = 24;
    } else if (newR > 3 && newR <= 14) {
      volt = 48;
    } else if (newR > 9 && newR < 14) {
      volt = 60;
    }
    return volt;
  }

  // STEEP 2
//B3 CAPACITY
  int calculateB3Cp() {
    var b3c;
    // b3c = Edaily x DOA / DOD X SV X B3E (EFFICIENCY)
    b3c = calculateDE() * 1 / 0.8 * calculateV() * 0.85;
    return b3c;
  }

  //STEEP 3
//BATTERY SIZING - NUMBERS OF B3 TO USE OR BUY
//FORMULAR = SYSTEM V/SELECTED B3V X B3 CAPACITY/ SB3C
  int calculateB3Size({required Battery sB3}) {
    selectedB3 = sB3;
    int size = 0;
    var result = calculateV() / sB3.volt * calculateB3Cp() / sB3.ah;
    size = result.round();
    return size;
  }

// NUMBER OF PARAlE CONNECTION
// FORMULAR  = B3C/SB3C
  calculatePConnet() {
    var pConnet = calculateB3Cp() / _sB3.ah;
    return pConnet;
  }

// NUMBER OF SERIES CONNECTION
// FORMULAR  = SV/SB3V
  calculateSconnet() {
    var result = calculateV() / _sB3.volt;
    return result;
  }

// NUMBER OF PV MODULES
//FORMULAR = ED/ PSH X PPR
//PSH - PEAK SUN HOUR
// PPR - PANEL PERFORMANCE RATION (0.65)
// SELECT REGION TO GET THE PSH
  // THIS CALCULATES THE TOTAL PANEL POWER NEEDED
  calculatePvModelsPW({required int region}) {
    var pv;
    pv = dailyEnergy / region * 0.65;
    _totalPvPower = pv;
    return _totalPvPower;
  }

  calculatePvNumbers({required Panel spv}) {
    // FORMULAR = REQUIRED WP/ SELECTED PANEL
    _selectedPanel = spv;
    var pvN = _totalPvPower / spv.w;
    _totalPvNumbers = pvN.round();
    return _totalPvNumbers;
  }

  // CHARGE CONTROLLER SIZING
  calculateChargeControl() {
    var controler;
    //FORMULAR = SIZE OF PANEL(WP)/ MAXIMUM POWER V OF ARRE (IMP)
    controler = _selectedPanel.w * _totalPvNumbers;
    var ctr2 = controler / _selectedPanel.imp;
    var result = ctr2 * 1.5;
    chargeController = result.round();
    return chargeController;
  }

  // INVERTER SIZING
  calculateInverter() {
    //FORMULAR = TOTAL POWER / INVERTER EFFICIENCY X 1.25
    var inv;
    inv = totalPower / 0.85 * 1.25;
    inverterSize = inv;
    return inv;
  }

  // CABLE SIZING
  calculateCable({required int len}) {
    // CABLE = 2XL X I X P / Vd
    var cabe = 2 * len * _selectedPanel.imp * _totalPvNumbers * 0.0179 / 0.03 * calculateV();
    return cabe;
  }
//
}

class Battery {
  static const String id = 'Battery';
  final String name;
  final int volt;
  final int ah;
  final double amount;
  Battery({this.name = 'Gel', required this.volt, required this.ah, this.amount = 0.0});

  factory Battery.fromJson(Map<dynamic, dynamic> passedJson) {
    return Battery(
      name: passedJson['name'],
      volt: passedJson['volt'],
      ah: passedJson['ah'],
      amount: passedJson['amount'],
    );
  }

  @override
  String toString() {
    return '{ $name, $volt, $ah, $amount}';
  }
}

class Message {
  final bool isUser;
  final String text;
  final bool isRead;
  const Message({this.isUser = true, required this.text, this.isRead = false});
}

class Panel {
  static const String id = 'Panel';
  final int volt;
  final int w;
  final double imp;
  final double amount;
  Panel({
    required this.volt,
    this.imp = 5.6,
    required this.w,
    this.amount = 0.0,
  });
  factory Panel.fromJson(Map<dynamic, dynamic> passedJson) {
    return Panel(
        volt: passedJson['volt'],
        w: passedJson['watt'],
        imp: passedJson['imp'],
        amount: passedJson['amount']);
  }
  @override
  String toString() {
    return '{$volt, $imp, $w, $amount}';
  }
}

class Climate {
  final String area;
  final double psh;
  final List<String> locations;
  Climate({required this.area, required this.psh, required this.locations});
//
}

class ChargeController {
  static const String id = 'Charger';
  final double amount;
  final int arms;
  final String type;
  const ChargeController({required this.amount, required this.arms, this.type = 'MPPT'});
  factory ChargeController.fromJson(Map<dynamic, dynamic> json) {
    return ChargeController(
      amount: json['amount'],
      arms: json['arms'],
      type: json['type'],
    );
  }

  @override
  String toString() {
    return '{ $amount, $arms, $type}';
  }
}

class Inverter {
  static const String id = 'Inverter';
  final double amount;
  final int watt;
  const Inverter({required this.amount, required this.watt});
  factory Inverter.fromJson(Map<dynamic, dynamic> passedJson) {
    return Inverter(amount: passedJson['amount'], watt: passedJson['watt']);
  }
  @override
  String toString() {
    return '{ $amount, $watt}';
  }
}

//`
class Processor with ChangeNotifier {
  late Battery _sB3;
  int totalPvPower = 0;
  int totalPvNumbers = 0;
  late Panel _selectedPanel;
  Battery? selectedB3;
  var chargeController;
  var inverterSize;
  int totalPower = 0;
  int dailyEnergy = 0;
  int systemVolt = 0;
  var b3c = 0;
  int b3Size = 0;
  var pvWatt; //
  var pvConnect;
  var srConnect;
  var cableSize;
  bool hasData = false;
  bool hasWatts = false;
  List<ItemBrain> houseLoad = [];
  List<ItemBrain> allLoad = [];
  List<Panel> allPanels = [];
  List<Battery> allBattery = [];
  List<ChargeController> allController = [];
  List<Inverter> allInverters = [];

  get gallLoad => allLoad;

//

  // Set Load
  void setLoad(List<ItemBrain> load) {
    allLoad = load;
    notifyListeners(); // Notify listeners when the value changes
  }

  void setNewDevice(bool val) {
    hasData = val;
    notifyListeners();
  }

  void setNewWatts(bool val) {
    hasWatts = val;
    notifyListeners();
  }

  // Set B3
  void setBattery(List<Battery> battery) {
    allBattery = battery;
    notifyListeners(); // Notify listeners when the value changes
  }

  // Set Panel
  void setPanel(List<Panel> panel) {
    allPanels = panel;
    notifyListeners(); // Notify listeners when the value changes
  }

  // Set Charge Controlers
  void setCharger(List<ChargeController> charger) {
    allController = charger;
    notifyListeners(); // Notify listeners when the value changes
  }

  // Set inverter
  void setInverter(List<Inverter> inverter) {
    allInverters = inverter;
    notifyListeners(); // Notify listeners when the value changes
  }

  // Add Load
  void addToLoad(ItemBrain load) {
    houseLoad.add(load);
    multiFuc();
    notifyListeners(); // Notify listeners when the value changes
  }

  void edditLoad(ItemBrain oldLoad, ItemBrain newLoad) {
    houseLoad.remove(oldLoad);
    houseLoad.add(newLoad);
    multiFuc();
    notifyListeners(); // Notify listeners when the value changes
  }

  void deleteLoad(
    ItemBrain oldLoad,
  ) {
    houseLoad.remove(oldLoad);
    multiFuc();
    notifyListeners();
  }

  void multiFuc() {
    calculateTP();
    calculateDE();
    calculateV();
    calculateB3Cp();
  }

  // Add Load`
  void removeLoad(ItemBrain load) {
    houseLoad.remove(load);
    if (houseLoad.isNotEmpty) {
      multiFuc();
    }
    notifyListeners(); // Notify listeners when the value changes
  }

  void editLoad(int index, ItemBrain load) {
    houseLoad[index] = load;
    multiFuc();
    notifyListeners(); // Notify listeners when the value changes
    //
  }

  void editLastLoad(ItemBrain load) {
    houseLoad.last = load;
    multiFuc();
    notifyListeners(); // Notify listeners when the value changes
    //
  }

  ItemBrain getLastLoad() {
    return houseLoad.last;
  }

  // calculate for totalPower
  int calculateTP() {
    totalPower = 0;
    for (ItemBrain i in houseLoad) {
      var p = i.unitPower * i.qty;
      i.totalPower = p;
      int index = houseLoad.indexOf(i);
      houseLoad[index] = i;
      totalPower += p;
    }
    notifyListeners(); // Notify listeners when the value changes
    return totalPower;
  } //```

  // calculate dailyEnergy
  int calculateDE() {
    dailyEnergy = 0;
    for (ItemBrain i in houseLoad) {
      var p = i.totalPower * i.dailyUsage;
      i.dailyEnergy = p;
      int index = houseLoad.indexOf(i);
      houseLoad[index] = i;
      dailyEnergy += p;
    }
    notifyListeners(); //```
    return dailyEnergy;
  }

  // STEEPS 1
//SOLVE FOR SYSTEM VOLTAGE . FORMULAR = DE/1000`
  int calculateV() {
    var result = dailyEnergy / 1000;
    // round result to int
    var newR = result.round();
    if (newR <= 2) {
      systemVolt = 12;
    } else if (newR > 1 && newR <= 4) {
      systemVolt = 24;
    } else if (newR > 3 && newR <= 14) {
      systemVolt = 48;
    } else if (newR > 14 && newR <= 60) {
      systemVolt = 60;
    } else if (newR > 60 && newR <= 130) {
      systemVolt = 96;
    } else if (newR > 130 && newR <= 500) {
      systemVolt = 240;
    }
    notifyListeners(); // Notify listeners when the value changes
    return systemVolt;
  }

  // STEEP 2
//B3 CAPACITY
  int calculateB3Cp() {
    //
    // b3c = Edaily x DOA / DOD X SV X B3E (EFFICIENCY)
    //
    var newb3 = dailyEnergy * 1;
    var newb4 = 0.8 * systemVolt * 0.85;
    var result = newb3 / newb4;
    b3c = result.toInt();
    //b3c = (dailyEnergy * 1 / 0.8 * systemVolt * 0.85) as int;
    notifyListeners();
    //
    return b3c;
    //
  }

  //STEEP 3
//BATTERY SIZING - NUMBERS OF B3 TO USE OR BUY
//FORMULAR = SYSTEM V/SELECTED B3V X B3 CAPACITY/ SB3C
  void calculateB3Size({required Battery sB3}) {
    selectedB3 = sB3;
    int size = 0;
    var x = calculateV() / sB3.volt;
    var y = calculateB3Cp() / sB3.ah;
    var result = x * y;
    size = result.round();
    b3Size = size;
    calculatePConnet();
    calculateSconnet();
    notifyListeners();
  }

//
// NUMBER OF PARAlE CONNECTION
// FORMULAR  = B3C/SB3C
  void calculatePConnet() {
    var pConnet = calculateB3Cp() / selectedB3!.ah;
    pvConnect = pConnet.round();
    notifyListeners();
  }

//
// NUMBER OF SERIES CONNECTION
// FORMULAR  = SV/SB3V
  void calculateSconnet() {
    var result = calculateV() / selectedB3!.volt;
    srConnect = result.round();
    notifyListeners();
  }

// NUMBER OF PV MODULES
//FORMULAR = ED/ PSH X PPR
//PSH - PEAK SUN HOUR
// PPR - PANEL PERFORMANCE RATION (0.65)
// SELECT REGION TO GET THE PSH
  // THIS CALCULATES THE TOTAL PANEL POWER NEEDED
  //
  calculatePvModelsPW({required double region}) {
    //
    var pv;
    var pv2 = region * 0.65;
    pv = dailyEnergy / pv2;
    totalPvPower = double.parse(pv.toString()).toInt();
    notifyListeners();
    return totalPvPower; //
  }

  void calculatePvNumbers({required Panel spv}) {
    // FORMULAR = REQUIRED WP/ SELECTED PANEL
    pvWatt = spv.w;
    _selectedPanel = spv;
    var pvN = totalPvPower / spv.w;
    totalPvNumbers = pvN.round();
    calculateChargeControl();
    calculateInverter();
    notifyListeners();
    //
  }

  // CHARGE CONTROLLER SIZING
  void calculateChargeControl() {
    var controler;
    //FORMULAR = SIZE OF PANEL(WP)/ MAXIMUM POWER V OF ARRE (IMP)
    // controler = _selectedPanel.w * totalPvNumbers;
    // var ctr2 = controler / _selectedPanel.imp;

    var ctr2 = _selectedPanel.imp * totalPvNumbers;
    var result = ctr2 * 1.5;
    chargeController = result.round();

    notifyListeners();
  }

  // INVERTER SIZING
  void calculateInverter() {
    //FORMULAR = TOTAL POWER / INVERTER EFFICIENCY X 1.25
    var inv;
    inv = totalPower / 0.85;
    var int2 = inv * 1.25;
    inverterSize = int2.round();
    notifyListeners();
  }

  // CABLE SIZING
  calculateCable({required int len}) {
    // CABLE = 2XL X I X P / Vd
    var cabe = 2 * len * _selectedPanel.imp * totalPvNumbers * 0.0179;
    var cab2 = 0.03 * calculateV();
    var size = cabe / cab2;
    cableSize = size.round();
    if (kDebugMode) {
      print(cableSize);
      print('The cable size is');
    }
    notifyListeners(); // Notify listeners when the value changes
    return cabe;
  }

  clearLaod() {
    if (houseLoad.isNotEmpty) {
      houseLoad.removeLast();
      multiFuc();
    }
    notifyListeners();
  }

  // TOTAL POWER/ VOLT AND EDAILY CALCULATION
  int calculateTpVolt({required int totalP, required int eDaily, required int sv}) {
    totalPower = totalP;
    dailyEnergy = eDaily;
    // if vote is note giving
    if (sv <= 0) {
      systemVolt = calculateV();
    } else {
      systemVolt = sv;
    }

    calculateB3Cp();
    notifyListeners();
    return b3c;
  }
//
}

//`
class SingleProcessor with ChangeNotifier {
  int totalPvPower = 0;
  int totalPvNumbers = 0;
  late Panel _selectedPanel;
  Battery? selectedB3;
  var chargeController;
  var inverterSize;
  int totalPower = 0;
  int dailyEnergy = 0;
  int systemVolt = 0;
  var b3c = 0;
  int b3Size = 0;
  var pvWatt; //
  var pvConnect;
  var srConnect;
  var cableSize;

//

  // calculate for totalPower
  int calculateTP(int unitPower, int qty) {
    totalPower = unitPower * qty;
    notifyListeners();
    return totalPower;
  } //```

  // calculate dailyEnergy
  int calculateDE({required int totalPower, required int dailyUsage}) {
    dailyEnergy = totalPower * dailyUsage;
    notifyListeners();
    return dailyEnergy;
  }

  // STEEPS 1
//SOLVE FOR SYSTEM VOLTAGE . FORMULAR = DE/1000`
  int calculateV({required int dailyEnergy}) {
    var result = dailyEnergy / 1000;
    // round result to int
    var newR = result.round();

    if (newR <= 2) {
      systemVolt = 12;
    } else if (newR > 1 && newR <= 4) {
      systemVolt = 24;
    } else if (newR > 3 && newR <= 14) {
      systemVolt = 48;
    } else if (newR > 14 && newR <= 60) {
      systemVolt = 60;
    } else if (newR > 60 && newR <= 130) {
      systemVolt = 96;
    } else if (newR > 130 && newR <= 500) {
      systemVolt = 240;
    }
    return systemVolt;
  }

  // STEEP 2
//B3 CAPACITY
  int calculateB3Cp({required int dailyEnergy, required int systemVolt}) {
    //
    // b3c = Edaily x DOA / DOD X SV X B3E (EFFICIENCY)
    //
    var newb3 = dailyEnergy * 1;
    var newb4 = 0.8 * systemVolt * 0.85;
    var result = newb3 / newb4;
    b3c = result.toInt();
    //b3c = (dailyEnergy * 1 / 0.8 * systemVolt * 0.85) as int;

    return b3c;
    //
  }

  //STEEP 3
//BATTERY SIZING - NUMBERS OF B3 TO USE OR BUY
//FORMULAR = SYSTEM V/SELECTED B3V X B3 CAPACITY/ SB3C
  int calculateB3Size({required Battery sB3, required int systemV, required int b3Cap}) {
    selectedB3 = sB3;
    var result = systemV / sB3.volt * b3Cap / sB3.ah;
    return result.round();
  }

//
// NUMBER OF PARAlE CONNECTION
// FORMULAR  = B3C/SB3C
  int calculatePConnet({
    required int b3Sc,
    required Battery selectedB3,
  }) {
    var pConnet = b3Sc / selectedB3.ah;
    return pConnet.round();
  }

//
// NUMBER OF SERIES CONNECTION
// FORMULAR  = SV/SB3V
  int calculateSconnet({required int systemV, required Battery selectedB3}) {
    var result = systemV / selectedB3.volt;
    return result.round();
  }

// NUMBER OF PV MODULES
//FORMULAR = ED/ PSH X PPR
//PSH - PEAK SUN HOUR
// PPR - PANEL PERFORMANCE RATION (0.65)
// SELECT REGION TO GET THE PSH
  // THIS CALCULATES THE TOTAL PANEL POWER NEEDED
  //
  int calculatePvModelsPW({required double region, required int dailyEnergy}) {
    //
    var pv;
    var pv2 = region * 0.65;
    pv = dailyEnergy / pv2;
    totalPvPower = double.parse(pv.toString()).toInt();
    return totalPvPower; //
  }

  int calculatePvNumbers({required Panel spv, required int totalPvPower}) {
    // FORMULAR = REQUIRED WP/ SELECTED PANEL
    pvWatt = spv.w;
    _selectedPanel = spv;
    var pvN = totalPvPower / spv.w;
    return pvN.round();
  }

  // CHARGE CONTROLLER SIZING
  int calculateChargeControl({required Panel sPv, required int totalPvPower}) {
    var controler;
    var pvNumbers = calculatePvNumbers(spv: sPv, totalPvPower: totalPvPower);
    //FORMULAR = SIZE OF PANEL(WP)/ MAXIMUM POWER V OF ARRE (IMP)
    controler = sPv.w * pvNumbers;
    var ctr2 = sPv.imp * pvNumbers * 1.5;
    var result = controler / ctr2;
    return result.round();
  }

  // INVERTER SIZING
  int calculateInverter({required int totalPower}) {
    //FORMULAR = TOTAL POWER / INVERTER EFFICIENCY X 1.25
    var inv;
    inv = totalPower / 0.85;
    var int2 = inv * 1.25;
    return int2.round();
  }

  // CABLE SIZING
  calculateCable(
      {required int len,
      required Panel selectedPanel,
      required int totalPvNumbers,
      required int systemV}) {
    // CABLE = 2XL X I X P / Vd
    var cabe = 2 * len * selectedPanel.imp * totalPvNumbers * 0.0179;
    var cab2 = 0.03 * systemVolt;
    var size = cabe / cab2;
    cableSize = size.round();
    return cabe;
  }

//
}

class ChatProvider with ChangeNotifier {
  List<Message> messages = [];
  bool isLoading = false;
  String input = '';
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  //final List<Content> chats = [];
  bool deviceSaved = false;
  String deviceRegisteredId = '';
  String? uniqueChatId;

  void updateInput(String text) {
    input = text;
    if (uniqueChatId == null) {
      generateChatId();
    }
    notifyListeners();
  }

  void restartChat() {
    uniqueChatId = null;
    notifyListeners();
  }

  void sendMessage() async {
    if (input.isEmpty) return;
    final Message message = Message(text: input);
    await _simulateTyping();
    updateMessage(message);
    _scrollToBottom();
    input = '';
    textController.clear();
    notifyListeners();
  }

  void updateMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }

  void emptyMessage() async {
    messages = [];
    await Db.deleteEntries(collName: 'chats', docName: deviceRegisteredId.toString());
    notifyListeners();
  }

  _simulateTyping() async {
    isLoading = true;
    notifyListeners();

    // SAVE CHAT HERE
    // Save device ID to Firestore
    var infor = await DeviceIdService.saveDeviceId();
    if (infor != null) {
      final deviceId = infor['deviceId'].toString();
      final data = infor['data'];
      final userDoc = db.collection('chats').doc(deviceId);
      final message = {
        'user': input,
        'createdAt': FieldValue.serverTimestamp(),
      };
      deviceRegisteredId = deviceId.toString();
      await Db.addcChatEntries(collName: deviceId, data: message, chatId: uniqueChatId.toString());
      if (deviceSaved == false) {
        userDoc.set(data);
        deviceSaved = true;
      }
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String? generateChatId() {
    var result = DateTime.now().millisecondsSinceEpoch + Random().nextInt(1000);
    uniqueChatId = result.toString();
    notifyListeners();
    return uniqueChatId;
  }
}

class DeviceIdService {
  static saveDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    Map<String, dynamic> details = {};

    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      details = {
        'version': androidInfo.version.release,
        'model': androidInfo.model,
        'product': androidInfo.product
      };
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
      details = {'version': iosInfo.systemVersion, 'model': iosInfo.model, 'product': iosInfo.name};
    }
    String? deviceId = "";
    if (androidInfo != null) {
      deviceId = androidInfo.id; // Use androidId for Android devices
    } else if (iosInfo != null) {
      deviceId = iosInfo.identifierForVendor; // Use identifierForVendor for iOS devices
    }
    if (deviceId!.isNotEmpty) {
      details['deviceId'] = generateUniqueId(deviceId);
      final data = {'deviceId': details['deviceId'], 'data': details};
      return data;
    }
  }
}

String generateUniqueId(String inputString) {
  final bytes = utf8.encode(inputString); // Convert string to bytes
  final hash = sha256.convert(bytes); // Generate SHA-256 hash
  return hash.toString(); // Convert hash to a string
}
