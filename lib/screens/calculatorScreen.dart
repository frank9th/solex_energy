import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'package:solex/componets/buildButton.dart';
import 'package:solex/model.dart';
import 'package:solex/screens/home.dart';

import '../componets/multi_color_container.dart';
import '../componets/resultCard.dart';
import '../data.dart';
import 'Item_sreen.dart';
import 'alertDialoge.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key, this.calcType});
  final CalcType? calcType;

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  TextEditingController hRcontroller = TextEditingController();
  TextEditingController tpRcontroller = TextEditingController();
  TextEditingController eDcontroller = TextEditingController();
  TextEditingController sVcontroller = TextEditingController();
  TextEditingController b3Ccontroller = TextEditingController();
  TextEditingController pshCcontroller = TextEditingController();
  TextEditingController controllerOne = TextEditingController();
  TextEditingController ccontrollerTwo = TextEditingController();
  TextEditingController controllerThree = TextEditingController();

  List searchItems = [];

  Battery? selectedB3;
  Panel? seletedPanel;
  bool hideCalButton = false;

  bool isActive = false;
  bool showResult = false;
  String _output = "0";
  String _input = "";
  String symbol = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _input = "";
      } else if (buttonText == "=") {
        _output = _calculate(_input);
        _input = "";
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  String _calculate(String input) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  _searchPanel(String text, List<Panel> allPanels) {
    final searchResult =
        allPanels.where((i) => i.w.toString().contains(text.toLowerCase())).toList();
    final result = {...searchResult}.toList();
    setState(() {
      searchItems = result;
    });
  }

  @override
  void initState() {
    if (widget.calcType == CalcType.chargeCtrl) {
      final process = Provider.of<Processor>(context, listen: false);
      searchItems = process.allPanels; //panelBank;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brain = Provider.of<SingleProcessor>(context);
    final process = Provider.of<Processor>(context);
    Widget buildButtonTwo(String label,
        {Color bgColor = Colors.white, Color textColor = Colors.black, Function()? onPress}) {
      return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(bgColor)),
        onPressed: onPress,
        child: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 12),
        ),
      );
    }

    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color
    Color? cardShColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54 // Dark theme color
        : Colors.black;
    final CalcType? currentType = widget.calcType;
    Widget buildAnswer() {
      if (currentType == CalcType.voltEd) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //this places the cm at the base of the HERO NUMBER
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      process.systemVolt.toString(),
                      style: const TextStyle(
                        fontSize: 38.0,
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Text('v',
                        style: TextStyle(fontSize: 10.0, color: cardShColor) //kLableTextStyle,
                        )
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: ResultCard(
                      text: process.selectedB3 == null ? '0' : process.selectedB3!.ah.toString(),
                      margin: 1.0,
                      height: 50,
                      label: 'battery size',
                      symbol: process.selectedB3 == null
                          ? 'Ah'
                          : 'Ah x ${process.b3Size} | ${process.selectedB3!.volt}v',
                    ),
                  ), // b3 size
                  //
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: ResultCard(
                      text: process.pvConnect != null ? process.pvConnect.toString() : '0',
                      margin: 1.0,
                      height: 50,
                      label: 'Parallel Conn',
                      symbol: 'PRc',
                    ),
                  ),
                  Expanded(
                    child: ResultCard(
                      text: process.srConnect != null ? process.srConnect.toString() : '0',
                      margin: 1.0,
                      height: 50,
                      label: 'Series Conn',
                      symbol: 'SRc',
                    ),
                  ), //parale
                  //

                  // series
                ],
              ),
              Row(
                children: [
                  //jj
                  Expanded(
                    child: ResultCard(
                      hasColor: true,
                      color: Colors.blueGrey.withOpacity(0.8),
                      text: process.b3c.toString(),
                      margin: 1.0,
                      height: 50,
                      label: 'Battery Cap',
                      symbol: 'Ah',
                    ),
                  ), //b3cap
                  Expanded(
                    child: ResultCard(
                      color: Colors.brown,
                      hasColor: true,
                      text: process.chargeController != null
                          ? process.chargeController.toString()
                          : '0',
                      margin: 1.0,
                      height: 50,
                      label: 'Charge Ctrl',
                      symbol: 'A',
                    ),
                  ),
                ],
              ),
              //
              Row(
                children: [
                  Expanded(
                    child: ResultCard(
                      hasColor: true,
                      color: Colors.indigoAccent.withOpacity(0.6),
                      text: process.totalPvPower.toString(),
                      margin: 1.0,
                      height: 50,
                      label: 'PV Model (wp)', //
                      symbol: process.pvWatt == null
                          ? 'w'
                          : '${process.pvWatt}w x ${process.totalPvNumbers}',
                    ),
                  ),
                ],
              ), // pv model

              Row(
                children: [
                  Expanded(
                    child: ResultCard(
                      hasColor: true,
                      color: Colors.purple.withOpacity(0.4),
                      text: process.inverterSize != null ? process.inverterSize.toString() : '0',
                      margin: 1.0,
                      height: 50,
                      label: 'Inverter',
                      symbol: 'VA',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(child: Text('Solve for: ')),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: buildButtonTwo('B3 Size', onPress: () {
                  showDialog(context: context, builder: (context) => const B3DialogBox());
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: buildButtonTwo('PV (w)', onPress: () {
                  //
                  showDialog(context: context, builder: (context) => const PanelDialogeBox());
                }),
              ),

              const SizedBox(
                height: 20,
              ),

              MultiColorContainer(
                text: 'ADVANCE ANALYSIS',
                onPress: () {
                  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                  final String prompt =
                      'Do a quick system analysis for a Total power of ${process.totalPower}W, Daily Energy(Edaily ) '
                      'of ${process.dailyEnergy}Wh with a system voltage of ${process.systemVolt}v';
                  chatProvider.updateInput(prompt);
                  chatProvider.sendMessage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              )
            ],
          ),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //this places the cm at the base of the HERO NUMBER
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Center(
              child: Text(
                _output.toString(),
                style: const TextStyle(
                  fontSize: 48.0,
                ),
              ),
            ),
            const SizedBox(
              width: 3.0,
            ),
            Text(symbol, style: TextStyle(fontSize: 10.0, color: cardShColor) //kLableTextStyle,
                )
          ],
        );
      }
    }

    Widget data = Text(
      _output,
      style: const TextStyle(fontSize: 48.0),
    );

    Widget displyOptions() {
      if (currentType == CalcType.eD) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'Hours (t)',
                  hint: '',
                  controller: hRcontroller,
                )),
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'Total Power (w)',
                  controller: tpRcontroller,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (tpRcontroller.text.isNotEmpty && hRcontroller.text.isNotEmpty) {
                      try {
                        var result = brain.calculateDE(
                            totalPower: double.tryParse(tpRcontroller.text)!.toInt(),
                            dailyUsage: double.parse(hRcontroller.text).toInt());
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'wh';
                          eDcontroller.text = _output;
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.sV) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'eDaily (wh)',
                  hint: '',
                  controller: eDcontroller,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (eDcontroller.text.isNotEmpty) {
                      try {
                        var result = brain.calculateV(
                            dailyEnergy: double.tryParse(eDcontroller.text)!.toInt());
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'V';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.b3Cap) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'EDaily (wh)',
                  hint: '',
                  controller: eDcontroller,
                )),
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'System Volt (v)',
                  controller: sVcontroller,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (eDcontroller.text.isNotEmpty && sVcontroller.text.isNotEmpty) {
                      try {
                        var result = brain.calculateB3Cp(
                            dailyEnergy: double.tryParse(eDcontroller.text)!.toInt(),
                            systemVolt: double.tryParse(sVcontroller.text)!.toInt());
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'Ah';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.b3Size) {
        searchItems = batteryBank;
        if (selectedB3 == null) {
          hideCalButton = true;
        } else {
          hideCalButton = false;
        }
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // b3 capacity
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'System B3c (ah)',
                  hint: '',
                  controller: b3Ccontroller,
                )),
            // system vote
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'Volt (v)',
                  hint: '',
                  controller: sVcontroller,
                )),
            // Selected B3

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                //color: Colors.white,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select your preferred Battery',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  //
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchItems.length, //searchItems.length,
                      itemBuilder: (context, index) {
                        final Battery item = searchItems[index];
                        // final process = Provider.of<Processor>(context);
                        return Card(
                          child: ListTile(
                            title: Text('${item.ah.toString()}ah'),
                            subtitle: Text(item.name),
                            trailing: Text('${item.volt}v'),
                            onTap: () {
                              setState(() {
                                selectedB3 = item;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            selectedB3 != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: const Text('Picked: '),
                        title: Text('${selectedB3!.ah.toString()}ah'),
                        subtitle: Text(selectedB3!.name),
                        trailing: Text('${selectedB3!.volt}v'),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 10,
                  ),

            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (b3Ccontroller.text.isNotEmpty && selectedB3 != null) {
                      try {
                        int volt = double.tryParse(sVcontroller.text)!.toInt();
                        int b3Cap = double.tryParse(b3Ccontroller.text)!.toInt();
                        var result =
                            brain.calculateB3Size(sB3: selectedB3!, systemV: volt, b3Cap: b3Cap);
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'x ${selectedB3?.ah}ah | ${selectedB3?.volt}v';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.pvModel) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'eDaily (wh)',
                  hint: '',
                  controller: controllerOne,
                )),
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'PHS',
                  hint: '',
                  controller: ccontrollerTwo,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (controllerOne.text.isNotEmpty && ccontrollerTwo.text.isNotEmpty) {
                      try {
                        var edaily = double.tryParse(controllerOne.text)!.toInt();
                        var phs = double.tryParse(ccontrollerTwo.text)!;
                        var result = brain.calculatePvModelsPW(region: phs, dailyEnergy: edaily);
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'wp';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.chargeCtrl) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.black45.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: NoKeyboardTextInput(
                        title: 'Total PV (w)',
                        hint: '',
                        controller: controllerOne,
                      )),
                  const SizedBox(height: 16),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: ccontrollerTwo,
                        autofocus: true,
                        onChanged: (String v) {
                          _searchPanel(v, process.allPanels);
                          // Handle search logic here
                          // You can filter data based on user input
                        },
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search panel by watts',
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  //
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchItems.length, //searchItems.length,
                      itemBuilder: (context, index) {
                        final Panel item = searchItems[index];
                        return Card(
                          //
                          child: ListTile(
                            title: Text('${item.w.toString()}w'),
                            trailing: Text('${item.volt}v'),
                            onTap: () {
                              setState(() {
                                seletedPanel = item;
                              });

                              // process.calculatePvNumbers(spv: item);
                              //Navigator.pop(context);
                              //

                              //Navigator.pop(context, item);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            seletedPanel != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          '${seletedPanel?.w.toString()}w',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '${seletedPanel?.volt}v',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 10,
                  ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (controllerOne.text.isNotEmpty && seletedPanel != null) {
                      try {
                        int pvPw = double.tryParse(controllerOne.text)!.toInt();
                        var result =
                            brain.calculateChargeControl(sPv: seletedPanel!, totalPvPower: pvPw);
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'A';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
        //data = const NoKeyboardTextInput();
      } else if (currentType == CalcType.invert) {
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'Total (w)',
                  hint: '',
                  controller: controllerOne,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (controllerOne.text.isNotEmpty) {
                      try {
                        var totalP = double.tryParse(controllerOne.text)!.toInt();
                        var result = brain.calculateInverter(totalPower: totalP);
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'VA';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      } else if (currentType == CalcType.voltEd) {
        // Calculate with Total Energy, voltage and daily energy
        data = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'Total p (w)',
                  hint: '',
                  controller: controllerOne,
                )),
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'eDaily (wh)',
                  controller: ccontrollerTwo,
                )),
            Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0)),
                child: NoKeyboardTextInput(
                  title: 'System Volt (V)',
                  controller: controllerThree,
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: BuildBotton(
                  label: 'Calculate',
                  bgColor: Colors.greenAccent,
                  onPress: () {
                    if (controllerOne.text.isNotEmpty && ccontrollerTwo.text.isNotEmpty) {
                      try {
                        var tp = double.tryParse(controllerOne.text)!.toInt();
                        var edaily = double.tryParse(ccontrollerTwo.text)!.toInt();
                        String sv = '0';
                        if (controllerThree.text.isNotEmpty) {
                          sv = controllerThree.text;
                        }
                        var result = process.calculateTpVolt(
                            totalP: tp, eDaily: edaily, sv: double.tryParse(sv)!.toInt());
                        setState(() {
                          _output = result.toString();
                          showResult = true;
                          symbol = 'ah';
                        });
                      } catch (e) {}
                    }
                  }),
            )
          ],
        );
      }
      return data;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: showResult ? buildAnswer() : displyOptions()),
        ),
        currentType != null
            ? const SizedBox.shrink()
            :
            // Regular buttons
            Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                      _buildButton("-"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                      _buildButton("*"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
                      _buildButton("/"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton("C"),
                      _buildButton("0"),
                      _buildButton("="),
                      _buildButton("+"),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: MaterialButton(
        padding: const EdgeInsets.all(20.0),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class NoKeyboardTextInput extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const NoKeyboardTextInput(
      {super.key,
      required this.title,
      required this.controller,
      this.hint = '',
      this.keyboardType = TextInputType.number});

  @override
  State<NoKeyboardTextInput> createState() => _NoKeyboardTextInputState();
}

class _NoKeyboardTextInputState extends State<NoKeyboardTextInput> {
  bool value = false;
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final process = Provider.of<Processor>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        // textAlign: TextAlign.center,
        keyboardType: widget.keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        controller: widget.controller,
        //  readOnly: true, // Make the TextFormField read-only
        decoration: InputDecoration(
            hintText: widget.title,
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.black45, fontSize: 16)),
        onChanged: (val) {
          if (val.isNotEmpty) {
            setState(() {
              value = true;
              process.setNewDevice(value);
            });
          } else {
            setState(() {
              value = false;
              process.setNewDevice(value);
            });
          }
        },
        onTap: () {},
      ),
    );
  }
}
