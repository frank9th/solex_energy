import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'model.dart';

List<Battery> batteryBank = [
  Battery(volt: 2, ah: 330),
  Battery(volt: 2, ah: 500),
  Battery(volt: 2, ah: 600),
  Battery(volt: 2, ah: 800),
  Battery(volt: 2, ah: 1000),
  Battery(volt: 2, ah: 1500),
  Battery(volt: 2, ah: 1890),
  Battery(volt: 2, ah: 2200),
  Battery(volt: 2, ah: 220),
  Battery(volt: 6, ah: 220),
  Battery(volt: 6, ah: 420),
  Battery(volt: 6, ah: 770),
  Battery(volt: 6, ah: 600),
  Battery(volt: 12, ah: 50),
  Battery(volt: 12, ah: 60),
  Battery(volt: 12, ah: 65),
  Battery(volt: 12, ah: 75),
  Battery(volt: 12, ah: 100),
  Battery(volt: 12, ah: 150),
  Battery(volt: 12, ah: 170),
  Battery(volt: 12, ah: 200),
  Battery(volt: 12, ah: 220),
  Battery(volt: 12, ah: 230),
  Battery(volt: 12, ah: 250),
  Battery(volt: 48, ah: 30, name: 'Lithium ion'),
  Battery(volt: 48, ah: 100, name: 'Lithium ion'),
  Battery(volt: 48, ah: 200, name: 'Lithium ion'),
];
List<Climate> climateBank = [
  Climate(area: 'Mangrove swamp', psh: 4, locations: ['Yenegoa', 'Lagos', 'PH']),
  //
  Climate(area: 'High rainforest', psh: 4.5, locations: ['Ibadan', 'Akwa', 'Enugu']),
  Climate(area: 'Guinea Savannah', psh: 5, locations: ['Abuja', 'Kaduna']),
  Climate(area: 'Sudan Savannah', psh: 5.5, locations: ['Kanji', 'Kano']),
  Climate(area: 'Sahel Savannah', psh: 6, locations: ['Sokoto']),
];
List<Panel> panelBank = [
  Panel(volt: 12, w: 5, imp: 5.8),
  Panel(volt: 12, w: 10, imp: 5.8),
  Panel(volt: 12, w: 20, imp: 8.8),
  Panel(volt: 12, w: 30, imp: 5.8),
  Panel(volt: 12, w: 40, imp: 5.8),
  Panel(volt: 12, w: 50, imp: 5.8),
  Panel(volt: 12, w: 60, imp: 5.8),
  Panel(volt: 12, w: 80, imp: 5.8),
  Panel(volt: 12, w: 85, imp: 5.8),
  Panel(volt: 12, w: 100, imp: 5.8),
  Panel(volt: 12, w: 130, imp: 5.8),
  Panel(volt: 12, w: 140, imp: 5.8),
  Panel(volt: 12, w: 150, imp: 5.8),
  Panel(volt: 12, w: 170, imp: 5.8),
  Panel(volt: 12, w: 180, imp: 5.8),
  Panel(volt: 12, w: 190, imp: 5.8),
  Panel(volt: 24, w: 200, imp: 8.8),
  Panel(volt: 24, w: 230, imp: 8.8),
  Panel(volt: 24, w: 250, imp: 8.8),
  Panel(volt: 12, w: 250, imp: 8.8),
  Panel(volt: 24, w: 280, imp: 8.6),
  Panel(volt: 24, w: 300, imp: 8.8),
  Panel(volt: 24, w: 320, imp: 8.8),
  Panel(volt: 24, w: 375, imp: 8.8),
  Panel(volt: 24, w: 380, imp: 8.8),
  Panel(volt: 24, w: 400, imp: 8.8),
  Panel(volt: 24, w: 450, imp: 12),
  Panel(volt: 24, w: 440, imp: 8.8),
];
List<ItemBrain> loadBank = [
  ItemBrain(load: 'Security bulbs', unitPower: 10, dailyUsage: 12, qty: 80),
  ItemBrain(load: 'Bush bar', unitPower: 15, dailyUsage: 12, qty: 6),
  ItemBrain(load: 'Projector', unitPower: 700, qty: 1, dailyUsage: 12),
  ItemBrain(load: 'Tv 42inc', unitPower: 100, qty: 20, dailyUsage: 12),
  ItemBrain(load: 'Tv 65inch', unitPower: 200, qty: 2, dailyUsage: 12),
  ItemBrain(load: 'Bulbs round mess h', unitPower: 15, qty: 25, dailyUsage: 12),
  ItemBrain(load: 'Inside mess hall', unitPower: 15, qty: 25, dailyUsage: 12),
  ItemBrain(load: 'Chandelier', unitPower: 100, qty: 7, dailyUsage: 12),
  ItemBrain(load: 'Other bulbs', unitPower: 15, qty: 12, dailyUsage: 12),
  ItemBrain(load: 'Lobby', unitPower: 15, qty: 12, dailyUsage: 12),
  ItemBrain(load: 'Rooms', unitPower: 15, qty: 9, dailyUsage: 12),
  ItemBrain(load: 'Vip rooms', unitPower: 15, qty: 13, dailyUsage: 12),
  ItemBrain(load: 'Fans', unitPower: 120, qty: 25, dailyUsage: 12),
];
List<ChargeController> chargerBank = const [
  ChargeController(amount: 6000.00, arms: 5, type: 'PWM'),
  ChargeController(amount: 8500.00, arms: 10, type: 'PWM'),
  ChargeController(amount: 20000.00, arms: 20, type: 'PWM'),
  ChargeController(amount: 25000.00, arms: 30, type: 'PWM'),
  ChargeController(
    amount: 30000.00,
    arms: 40,
  ),
  ChargeController(
    amount: 135000.00,
    arms: 60,
  ),
  ChargeController(
    amount: 85000.00,
    arms: 80,
  ),
];
List<Inverter> inverterBank = const [
  Inverter(amount: 50000.00, watt: 700),
  Inverter(amount: 85000.00, watt: 1000),
  Inverter(amount: 12000.00, watt: 2500),
  Inverter(amount: 15000.00, watt: 3500),
  Inverter(amount: 210000.00, watt: 5000),
  Inverter(amount: 240000.00, watt: 6000),
  Inverter(amount: 26500.00, watt: 7500),
  Inverter(amount: 310000.00, watt: 10000),
  Inverter(amount: 420000.00, watt: 15000),
  Inverter(amount: 500000.00, watt: 20000),
];

//
//
final db = FirebaseFirestore.instance;

class Db {
  static getDocData({
    required String collectNam,
  }) async {
    List data = [];
    await db.collection(collectNam).get().then((value) {
      for (var i in value.docs) {
        var rawDa = i.data();
        data.add(rawDa);
      }
    }).onError((error, stackTrace) {});
    return data;
  }

  static Future<void> addEntries(
      {required String collName,
      required String docName,
      required Map<String, dynamic> data}) async {
    await db.collection(docName).doc(collName).set(data).catchError((e) {
      if (kDebugMode) {
        print('Error creating collection');
        print(e);
      }
      return e;
    }).whenComplete(() {
      if (kDebugMode) {
        print('Document saved');
      }
    });
  }

  static Future<void> addcChatEntries(
      {required String collName,
      required String chatId,
      required Map<String, dynamic> data}) async {
    await db.collection('chats').doc(collName).collection(chatId).add(data).catchError((e) {
      if (kDebugMode) {
        print('Error creating collection');
        print(e);
      }
      return e;
    }).whenComplete(() {
      if (kDebugMode) {
        print('Document saved');
      }
    });
  }

  static Future<void> deleteEntries({
    required String collName,
    required String docName,
  }) async {
    await db.collection(collName).doc(docName).delete().catchError((e) {
      if (kDebugMode) {
        print('Error deleting collection');
        print(e);
      }
      return e;
    }).whenComplete(() {
      if (kDebugMode) {
        print('collection deleted');
      }
    });
  }

  static readObjectList(String collectName, context) async {
    List data = await Db.getDocData(collectNam: collectName);
    if (data.isNotEmpty) {
      final box = Provider.of<Processor>(context, listen: false);
      if (collectName == ItemBrain.id) {
        List<ItemBrain> deviceList = [];
        for (var i in data) {
          final ItemBrain device = ItemBrain.fromJson(i);
          deviceList.add(device);
        }
        box.setLoad(deviceList);
        if (kDebugMode) {
          print('Load set');
          print(deviceList);
        }
        //Battery
      } else if (collectName == Battery.id) {
        List<Battery> batteryList = [];
        for (var i in data) {
          final Battery b3 = Battery.fromJson(i);
          batteryList.add(b3);
        }
        box.setBattery(batteryList);
      }
      //Panel
      else if (collectName == Panel.id) {
        List<Panel> panelList = [];
        for (var i in data) {
          final Panel panel = Panel.fromJson(i);
          panelList.add(panel);
        }
        box.setPanel(panelList);
      }
      // Controller
      else if (collectName == ChargeController.id) {
        List<ChargeController> controlList = [];
        for (var i in data) {
          final ChargeController charge = ChargeController.fromJson(i);
          controlList.add(charge);
        }
        box.setCharger(controlList);
      }
      // Inverter
      else if (collectName == Inverter.id) {
        List<Inverter> invertList = [];
        for (var i in data) {
          final Inverter invert = Inverter.fromJson(i);
          invertList.add(invert);
        }
        box.setInverter(invertList);
      }
    }
  }

  static void saveItem({ItemBrain? item}) async {
    String docName = ItemBrain.id;
    if (item != null) {
      Map<String, dynamic> data = {
        'name': item.load,
        'watt': item.unitPower,
      };
      String collName = data['name'];
      await Db.addEntries(docName: docName, data: data, collName: collName);
    } else {
      for (var i in loadBank) {
        Map<String, dynamic> data = {
          'name': i.load,
          'watt': i.unitPower,
        };
        String collName = data['name'];
        await Db.addEntries(docName: docName, data: data, collName: collName);
      }
    }
  }

  static void saveBattery() async {
    String docName = Battery.id;
    for (var i in batteryBank) {
      Map<String, dynamic> data = {
        'name': i.name,
        'ah': i.ah,
        'volt': i.volt,
        'amount': i.amount,
      };
      String collName = '${i.ah}|${i.volt}v';
      await Db.addEntries(docName: docName, data: data, collName: collName);
    }
  }

  static void savePanel() async {
    print('Add panel clicked');
    String docName = Panel.id;
    for (var i in panelBank) {
      Map<String, dynamic> data = {
        'watt': i.w,
        'imp': i.imp,
        'volt': i.volt,
        'amount': i.amount,
      };
      String collName = '${i.w}|${i.volt}v';
      await Db.addEntries(docName: docName, data: data, collName: collName);
    }
  }

  static void saveController() async {
    String docName = ChargeController.id;
    for (var i in chargerBank) {
      Map<String, dynamic> data = {
        'arms': i.arms,
        'type': i.type,
        'amount': i.amount,
      };
      String collName = '${i.arms}ah';
      await Db.addEntries(docName: docName, data: data, collName: collName);
    }
  }

  static void saveInverter() async {
    String docName = Inverter.id;
    for (var i in inverterBank) {
      Map<String, dynamic> data = {
        'watt': i.watt,
        'amount': i.amount,
      };
      String collName = '${i.watt}w';
      await Db.addEntries(docName: docName, data: data, collName: collName);
    }
  }

  static getStreamDocData({
    required String collectNam,
  }) async {
    List data = [];
    Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection(collectNam).snapshots();
    _stream.listen((QuerySnapshot snapshot) {
      data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
    return data;
  }
}
