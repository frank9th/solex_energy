import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solex/model.dart';
import 'package:solex/screens/home.dart';
import 'package:solex/screens/varable_screen.dart';
import '../componets/custom_expansion_tile.dart';
import '../componets/editLoad.dart';
import '../componets/multi_color_container.dart';
import '../componets/resultCard.dart';
import '../data.dart';
import 'alertDialoge.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});
  @override
  _AuditScreenState createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  bool isExpanded = false;
  List activeItem = [];
  bool isOpen = false;
  Widget getOpenIcon(item) {
    var icon = const Icon(Icons.arrow_drop_down_outlined);
    if (activeItem.isNotEmpty) {
      bool hasItem = activeItem.contains(item);
      if (hasItem == true && isOpen == true) {
        icon = const Icon(Icons.arrow_drop_up_rounded);
      } else {
        const Icon(Icons.arrow_drop_down_outlined);
      }
    }

    return icon;
  }

  @override
  void initState() {
    Db.readObjectList(ItemBrain.id, context);
    setState(() {
      isExpanded = !isExpanded;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brain = Provider.of<Processor>(context);
    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800] // Dark theme color
        : Colors.grey[100];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color

    return Scaffold(
      /*
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/sl4.png',
          fit: BoxFit.contain,
          height: 50,
          width: 80,
        ),
        backgroundColor: Colors.amber,
        actions: [
          /*
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContentScreen()),
                  );
                },
                icon: const Icon(
                  Icons.notes,
                  color: Colors.white,
                )),
          ),

           */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.contact_support,
                  color: Colors.white,
                )),
          ),
          //

          //
        ],
      ),
      
       */
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*
                    SizedBox(
                      height: 30,
                      child: Image.asset(
                        'assets/images/sl4.png',
                        fit: BoxFit.contain,
                        height: 50,
                        width: 80,
                      ),
                    ),

                     */

                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isExpanded ? Colors.blue : null,
                                ),
                                child: Text(
                                  'Basic Analysis',
                                  style: TextStyle(fontSize: 12, color: cardHColor),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const VarableScreen()),
                                  );
                                },
                                child: Text(
                                  'Advance Analysis',
                                  style:
                                      TextStyle(fontSize: 12, color: cardHColor.withOpacity(0.6)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                            child: Text(
                              'Add devices below and calculate for various parameters',
                              style: TextStyle(
                                fontSize: 12,
                                color: cardHColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context, builder: (context) => const LoadDialogBox());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: const Text(
                                '+ Add Appliances',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //Table section
                    SizedBox(
                      height: 250,
                      child: ListView(
                        children: brain.houseLoad
                            .map((item) => Card(
                                  child: CustomExpansionTile(
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        isOpen = value;
                                        bool hasItem = activeItem.contains(item);

                                        if (hasItem == false && value) {
                                          activeItem.add(item);
                                        } else {
                                          activeItem.remove(item);
                                        }
                                      });
                                    },
                                    title: Row(
                                      children: [Text(item.load), getOpenIcon(item)],
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                        child: Container(
                                                          width: 250,
                                                          height: 300,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(20.0),
                                                            color: Colors.white,
                                                          ),
                                                          child: NewLoadFiled(
                                                            isSetting: false,
                                                            item: item,
                                                          ),
                                                        ),
                                                      ));
                                              // Handle edit action
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              size: 15,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              brain.deleteLoad(item);
                                              // Handle delete action
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Quantity: ${item.qty} ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: cardHColor.withOpacity(0.5)),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              VerticalDivider(
                                                color: cardHColor,
                                              ),
                                              Text(
                                                'Unit watt: ${item.unitPower}w',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: cardHColor.withOpacity(0.5)),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              VerticalDivider(
                                                color: cardHColor,
                                              ),
                                              Text(
                                                'Hourly Usage: ${item.dailyUsage}hrs ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: cardHColor.withOpacity(0.5)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        brain.houseLoad.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Expert Options',
                                        style: TextStyle(
                                            color: cardHColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Calculate for:',
                                        style: TextStyle(
                                            color: cardHColor.withOpacity(0.6), fontSize: 12),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AdvanceOption(
                                        title: 'Battery Size',
                                        onpress: brain.houseLoad.isNotEmpty
                                            ? () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => const B3DialogBox());
                                              }
                                            : null,
                                      ),
                                      AdvanceOption(
                                        title: 'Pv Model',
                                        onpress: brain.houseLoad.isNotEmpty
                                            ? () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => const PanelDialogeBox());
                                              }
                                            : null,
                                      ),
                                      AdvanceOption(
                                        title: 'Cable Size',
                                        onpress: brain.houseLoad.isNotEmpty
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return const EditLoad(
                                                      isCable: true,
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        FloatingActionButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          backgroundColor: containerColor,
                          onPressed: brain.houseLoad.isNotEmpty
                              ? () {
                                  final chatProvider =
                                      Provider.of<ChatProvider>(context, listen: false);
                                  List promptList = [];

                                  for (var item in brain.houseLoad) {
                                    String rawP =
                                        '${item.qty} ${item.load} of ${item.unitPower}w for ${item.dailyUsage}hrs per day ';
                                    promptList.add(rawP);
                                  }
                                  final String prompt =
                                      'Perform system design for; ${promptList.join(', ')}';
                                  chatProvider.updateInput(prompt);
                                  chatProvider.sendMessage();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  );
                                }
                              : () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                                },
                          child: Image.asset(
                            'assets/images/gemini-icon.png',
                            fit: BoxFit.contain,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ],
                    ),

                    // Result sections
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ResultCard(
                                text: brain.totalPower.toString(),
                                height: 50,
                                label: 'TOTAL POWER',
                                symbol: 'w',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                text: brain.dailyEnergy.toString(),
                                height: 50,
                                label: 'DAILY ENERGY',
                                symbol: 'wh',
                              ),
                            ),
                            //
                            Expanded(
                              child: ResultCard(
                                hasColor: true,
                                color: Colors.teal.withOpacity(0.8),
                                text: brain.systemVolt.toString(),
                                margin: 1.0,
                                height: 50,
                                label: 'SYSTEM VOLT',
                                symbol: 'v',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            //
                            Expanded(
                              child: ResultCard(
                                hasColor: true,
                                color: Colors.blueGrey.withOpacity(0.8),
                                text: brain.b3c.toString(),
                                margin: 1.0,
                                height: 50,
                                label: 'Battery Cap',
                                symbol: 'Ah',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                hasColor: true,
                                color: Colors.indigoAccent.withOpacity(0.6),
                                text: brain.totalPvPower.toString(),
                                margin: 1.0,
                                height: 50,
                                label: 'PV Model (wp)', //
                                symbol: brain.pvWatt == null
                                    ? 'w'
                                    : '${brain.pvWatt}w x ${brain.totalPvNumbers}',
                              ),
                            ),
                            //
                            Expanded(
                              child: ResultCard(
                                hasColor: true,
                                color: Colors.purple.withOpacity(0.4),
                                text: brain.inverterSize != null
                                    ? brain.inverterSize.toString()
                                    : '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Inverter',
                                symbol: 'VA',
                              ),
                            ),
                          ],
                        ),
                        //
                        Row(
                          children: [
                            Expanded(
                              child: ResultCard(
                                text: brain.selectedB3 == null
                                    ? '0'
                                    : brain.selectedB3!.ah.toString(),
                                margin: 1.0,
                                height: 50,
                                label: 'battery size',
                                symbol: brain.selectedB3 == null
                                    ? 'Ah'
                                    : 'Ah x ${brain.b3Size} | ${brain.selectedB3!.volt}v',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                text: brain.pvConnect != null ? brain.pvConnect.toString() : '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Parallel Conn',
                                symbol: 'PRc',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                text: brain.srConnect != null ? brain.srConnect.toString() : '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Series Conn',
                                symbol: 'SRc',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ResultCard(
                                color: Colors.brown,
                                hasColor: true,
                                text: brain.chargeController != null
                                    ? brain.chargeController.toString()
                                    : '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Charge Ctrl',
                                symbol: 'A',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                text: brain.cableSize != null ? brain.cableSize.toString() : '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Cable size',
                                symbol: 'mm',
                              ),
                            ),
                            Expanded(
                              child: ResultCard(
                                hasColor: true,
                                color: Colors.black.withOpacity(0.4),
                                text: '0',
                                margin: 1.0,
                                height: 50,
                                label: 'Estimated Cost',
                                symbol: 'NGN',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      /*
      floatingActionButton: MultiColorContainer(
        text: '',
        onPress: () {},
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FloatingActionButton(
            elevation: 10.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: containerColor,
            onPressed: brain.houseLoad.isNotEmpty
                ? () {
                    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                    List promptList = [];

                    for (var item in brain.houseLoad) {
                      String rawP =
                          '${item.qty} ${item.load} of ${item.unitPower}w for ${item.dailyUsage}hrs per day ';
                      promptList.add(rawP);
                    }
                    final String prompt =
                        'Perform system design for this appliances; ${promptList.toString().trim()}';
                    chatProvider.updateInput(prompt);
                    chatProvider.sendMessage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
            child: Image.asset(
              'assets/images/gemini-icon.png',
              fit: BoxFit.contain,
              height: 40,
              width: 40,
            ),
          ),
        ),
      ),

       */
    );
  }
}

class AdvanceOption extends StatelessWidget {
  final String title;
  final Function()? onpress;
  const AdvanceOption({
    super.key,
    required this.title,
    this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 30,
        //width: 92,
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: TextButton(
          onPressed: onpress,
          child: Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
