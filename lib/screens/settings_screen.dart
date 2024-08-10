import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solex/model.dart';
import 'package:solex/screens/Item_sreen.dart';
import 'package:solex/screens/alertDialoge.dart';

import '../componets/buildButton.dart';

enum Menu { load, panel, charger, battery, inverter }

class SettingsScreen extends StatefulWidget {
  static String id = 'settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool openMenue = false;
  Menu activeMenu = Menu.load;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                setState(() {
                  if (openMenue) {
                    openMenue = false;
                  } else {
                    openMenue = true;
                  }
                });
              },
              title: const Text(
                'Select Menu',
                style: TextStyle(color: Colors.black45),
              ),
              trailing: Icon(openMenue ? Icons.arrow_drop_down : Icons.arrow_right),
            ),
          ),
          openMenue
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('Load', onPress: () {
                      setState(() {
                        activeMenu = Menu.load;
                      });
                    }),
                    buildButton('Panels', onPress: () {
                      setState(() {
                        activeMenu = Menu.panel;
                      });
                    }),
                    buildButton('Chargers',
                        onPress: () => setState(() {
                              activeMenu = Menu.charger;
                            })),
                    buildButton('Inverters',
                        onPress: () => setState(() {
                              activeMenu = Menu.inverter;
                            })),
                  ],
                )
              : const SizedBox.shrink(),
          bodyChild(),
        ],
      ),
    );
  }

  Widget bodyChild() {
    Widget data = const Expanded(
      child: LoadDialogBox(
        isSetting: true,
      ),
    );
    if (activeMenu == Menu.panel) {
      data = const SizedBox(
        child: Center(
          child: Text('Panel'),
        ),
      );
    } else if (activeMenu == Menu.battery) {
      data = SizedBox(
        child: Center(
          child: Text('B3'),
        ),
      );
    } else if (activeMenu == Menu.charger) {
      data = SizedBox(
        child: Center(
          child: Text('Charger'),
        ),
      );
    } else if (activeMenu == Menu.inverter) {
      data = SizedBox(
        child: Center(
          child: Text('inverter'),
        ),
      );
    }
    return data;
  }
}
