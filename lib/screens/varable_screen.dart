import 'package:flutter/material.dart';
import 'package:solex/screens/settings_screen.dart';

import '../data.dart';
import '../main.dart';
import 'calculatorScreen.dart';
import 'home.dart';

class VarableScreen extends StatefulWidget {
  const VarableScreen({Key? key}) : super(key: key);

  @override
  State<VarableScreen> createState() => _VarableScreenState();
}

class _VarableScreenState extends State<VarableScreen> {
  final TextEditingController _controller = TextEditingController();
  var currentFunc;
  @override
  Widget build(BuildContext context) {
    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600] // Dark theme color
        : Colors.grey[100];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color
    Color? cardShColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54 // Dark theme color
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Center(
                        child: Text(
                          'Unlock Menu',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      content: NoKeyboardTextInput(
                        keyboardType: TextInputType.text,
                        title: 'Key',
                        controller: _controller,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              try {
                                final List data = await Db.getDocData(collectNam: 'unlocker');
                                String result = data.first['key'];
                                if (mounted) {
                                  if (_controller.text.toUpperCase() == result.toUpperCase()) {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => const SettingsScreen()));
                                  }
                                }
                              } catch (e) {}
                            },
                            child: const Text('Proceed')),
                      ],
                    ));
          },
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/sl4.png'
                : 'assets/images/sl2.png',
            fit: BoxFit.contain,
            height: 50,
            width: 90,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                MyApp.themeNotifier.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              // Toggle the theme mode between light and dark
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey,
        height: MediaQuery.of(context).size.height, // Fixed height for the outer container
        child: Row(
          children: [
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isOpened ? MediaQuery.of(context).size.width - 150 : 0,
                color: containerColor?.withOpacity(0.7),
                child: isOpened
                    ? Calculator(
                        calcType: currentFunc,
                      )
                    : const SizedBox.shrink()),
            Expanded(
              flex: 1,
              child: Container(
                  color: containerColor?.withOpacity(0.5),
                  //height: 400, // Fixed height for the right column
                  child: const Calculator()),
            ),
            Container(
              width: 150,
              color: containerColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 100, // Fixed height for the first row
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: 200,
                          color: Colors.amber,
                          child: const Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('SYSTEM'),
                          )),
                        ),
                        ContainerButton(
                          isActive: currentFunc == CalcType.voltEd ? true : false,
                          lable: 'Installation',
                          onTap: () {
                            setState(() {
                              currentFunc = CalcType.voltEd;
                              isOpened = !isOpened;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // BUTTONS
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 200,
                        color: Colors.amber,
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('VARIABLES'),
                        )),
                      ),
                      ContainerButton(
                        isActive: currentFunc == CalcType.eD ? true : false,
                        lable: 'Daily Energy',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.eD;
                            isOpened = !isOpened;
                          });
                        },
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        isActive: currentFunc == CalcType.b3Cap ? true : false,
                        lable: 'Battery Cap',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.b3Cap;
                            isOpened = !isOpened;
                          });
                        },
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        lable: 'System Volt',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.sV;
                            isOpened = !isOpened;
                          });
                        },
                        isActive: currentFunc == CalcType.sV ? true : false,
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        lable: 'Battery Size',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.b3Size;
                            isOpened = !isOpened;
                          });
                        },
                        isActive: currentFunc == CalcType.b3Size ? true : false,
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        lable: 'Pv Model',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.pvModel;
                            isOpened = !isOpened;
                          });
                        },
                        isActive: currentFunc == CalcType.pvModel ? true : false,
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        lable: 'Charge Controler',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.chargeCtrl;
                            isOpened = !isOpened;
                          });
                        },
                        isActive: currentFunc == CalcType.chargeCtrl ? true : false,
                      ),
                      const CustumDivider(),
                      ContainerButton(
                        lable: 'Inverter Type',
                        onTap: () {
                          setState(() {
                            currentFunc = CalcType.invert;
                            isOpened = !isOpened;
                          });
                        },
                        isActive: currentFunc == CalcType.invert ? true : false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
