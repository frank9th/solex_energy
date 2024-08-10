import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solex/screens/chat_body.dart';
import 'package:solex/screens/settings_screen.dart';
import 'package:solex/screens/varable_screen.dart';

import '../data.dart';
import '../main.dart';
import '../model.dart';
import 'calculatorScreen.dart';
import 'Item_sreen.dart';

enum CalcType { eD, b3Cap, sV, b3Size, pvModel, chargeCtrl, invert, voltEd }

//
class HomeScreen extends StatefulWidget {
  final String? prompt;
  const HomeScreen({Key? key, this.prompt}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600] // Dark theme color
        : Colors.grey[100];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color

    //
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 45,
        titleSpacing: 3.0,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const SettingsScreen()));
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
            const SizedBox(
              width: 16,
            ),
            Image.asset(
              'assets/images/gemini-icon.png',
              fit: BoxFit.contain,
              height: 30,
              width: 30,
            ),
          ],
        ),
        centerTitle: true,
        //backgroundColor: Colors.amber,
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
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuditScreen()),
              );
              //
            },
            icon: const Icon(
              Icons.calculate,
              size: 30.0,
            ),
          )

           */

                //
                const SizedBox(
                  width: 5.0,
                ),
                /*
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AuditScreen()),
                          );
                        },
                        child: Text(
                          'Bas. Analysis',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: cardHColor),
                        ))),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VarableScreen()),
                          );
                        },
                        child: Text(
                          'Pro. Analysis',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: cardHColor),
                        ))),

                 */
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      chatProvider.restartChat();
                    },
                    child: Icon(
                      Icons.refresh,
                      color: cardHColor,
                    )),
              ],
            ),
          ),
          const Expanded(child: ChatBodyPart()),
        ],
      ),
    );
  }
}

class CustumDivider extends StatelessWidget {
  const CustumDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      color: Colors.amber.withOpacity(0.4),
    );
  }
}

class ContainerButton extends StatelessWidget {
  final String lable;
  final bool isActive;
  final Function()? onTap;
  const ContainerButton({
    super.key,
    required this.lable,
    this.onTap,
    required this.isActive,
  });

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
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        color: isActive ? Colors.amber.withOpacity(0.2) : containerColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  lable,
                  style: TextStyle(color: cardHColor, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*
  Widget car =   InkWell(
    onTap: () {},
    child: Container(
      width: 200,
      color: Colors.amber,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
            ),
            Text(
              lable,
              style: TextStyle(color: cardHColor, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );

   */
}

bool isOpened = false; // Boolean flag to track open/close state
