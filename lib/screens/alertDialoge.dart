import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solex/componets/buildButton.dart';
import 'package:solex/data.dart';

import '../componets/editLoad.dart';
import '../model.dart';
import 'calculatorScreen.dart';

// Load Alert Dialoge
class LoadDialogBox extends StatefulWidget {
  final bool isSetting;
  final ItemBrain? item;
  const LoadDialogBox({
    Key? key,
    this.isSetting = false,
    this.item,
  }) : super(key: key);

  @override
  State<LoadDialogBox> createState() => _LoadDialogBoxState();
}

//
class _LoadDialogBoxState extends State<LoadDialogBox> {
  final TextEditingController _searchController = TextEditingController();

  bool isSearch = true;
  bool autoFocus = false;

  List<ItemBrain> searchItems = [];
  List<ItemBrain> allItems = [];
  ItemBrain? selectedItem;

  List<Map<String, dynamic>> dataList = [];
  List<ItemBrain> allItemsData = [];

  _searchLoads(String text) {
    final searchResult =
        allItems.where((i) => i.load.toLowerCase().contains(text.toLowerCase())).toList();
    final result = {...searchResult}.toList();
    setState(() {
      searchItems = result;
    });
  }

  @override
  void initState() {
    retriveItem();
    if (widget.isSetting) {
      itemStream();
    } else {
      retriveItem();
    }
    super.initState();
  }

  void retriveItem() {
    final box = Provider.of<Processor>(context, listen: false);
    if (kDebugMode) {
      print(box.allPanels);
      print('all panels is above');
    }
    setState(() {
      autoFocus = true;
      allItems = box.allLoad;
      searchItems = allItems;
    });
  }

  void itemStream() {
    setState(() {
      autoFocus = false;
    });
    // Initialize the Firestore stream
    Stream<QuerySnapshot> _stream =
        FirebaseFirestore.instance.collection(ItemBrain.id).snapshots(includeMetadataChanges: true);
    // Listen to the stream and update the list when data changes
    _stream.listen((QuerySnapshot snapshot) {
      dataList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      final List<ItemBrain> newItemList = [];
      for (var i in dataList) {
        final ItemBrain item = ItemBrain.fromJson(i);
        newItemList.add(item);
      }
      setState(() {
        allItems = newItemList;
        searchItems = allItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: widget.isSetting ? MediaQuery.of(context).size.width : 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSearch
                  ? Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: isSearch ? false : true,
                                controller: _searchController,
                                autofocus: autoFocus,
                                onChanged: (String v) {
                                  _searchLoads(v);
                                  // Handle search logic here
                                  // You can filter data based on user input
                                },
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: isSearch ? 'Search loads' : 'Enter new load',
                                    hintStyle: const TextStyle(color: Colors.black)),
                              ),
                            ),
                            //
                            IconButton(
                              style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                                shape: MaterialStateProperty.all(
                                  const CircleBorder(),
                                ),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(left: 5.0, bottom: 5.0, top: 3.0)),
                              ),
                              tooltip: isSearch ? 'Enter new load' : 'Search loads',
                              //color: Colors.greenAccent,
                              onPressed: () {
                                if (isSearch) {
                                  setState(() {
                                    isSearch = false;
                                  });
                                } else {
                                  setState(() {
                                    isSearch = true;
                                  });
                                }
                              },
                              icon: Icon(
                                isSearch ? Icons.edit_note : Icons.search,
                                size: 25,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),
              isSearch
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchItems.length, //searchItems.length,
                        itemBuilder: (context, index) {
                          final ItemBrain item = searchItems[index];
                          final process = Provider.of<Processor>(context);
                          return Card(
                            child: ListTile(
                              title: Text(item.load.toUpperCase()),
                              trailing: Text('${item.unitPower}w'),
                              onTap: () {
                                if (widget.isSetting) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: EditLoad(
                                          item: item,
                                          watt: true,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  process.addToLoad(item);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : NewLoadFiled(
                      isSetting: widget.isSetting,
                      item: widget.item,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewLoadFiled extends StatefulWidget {
  final bool isSetting;
  final ItemBrain? item;
  const NewLoadFiled({Key? key, this.isSetting = false, this.item}) : super(key: key);

  @override
  State<NewLoadFiled> createState() => _NewLoadFiledState();
}

class _NewLoadFiledState extends State<NewLoadFiled> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController wattController = TextEditingController();
  final TextEditingController hrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        hrController.text = widget.item!.dailyUsage.toString();
        wattController.text = widget.item!.unitPower.toString();
        itemController.text = widget.item!.qty.toString();
      });
    }
  }

  bool hasData = false;
  bool hasWatts = false;
  @override
  Widget build(BuildContext context) {
    final process = Provider.of<Processor>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.item != null
            ? Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.item!.load,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Text('New Record'),
        const SizedBox(
          height: 10,
        ),
        Container(
            margin: const EdgeInsets.all(5.0),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.1), borderRadius: BorderRadius.circular(8.0)),
            child: NoKeyboardTextInput(
              keyboardType: widget.item == null ? TextInputType.text : TextInputType.number,
              title: widget.item == null ? 'Appliance name' : 'Input quantity',
              hint: '',
              controller: itemController,
            )),
        Container(
            margin: const EdgeInsets.all(5.0),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.1), borderRadius: BorderRadius.circular(8.0)),
            child: NoKeyboardTextInput(
              title: 'Watts (w)',
              hint: '',
              controller: wattController,
            )),
        Container(
            margin: const EdgeInsets.all(5.0),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.1), borderRadius: BorderRadius.circular(8.0)),
            child: NoKeyboardTextInput(
              title: 'Hourly usage',
              controller: hrController,
            )),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: process.hasData ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(50.0)),
                  //width: double.infinity,
                  child: TextButton(
                    child: Text(
                      'Finish',
                      style: TextStyle(color: process.hasData ? Colors.black : Colors.black45),
                    ),
                    onPressed: () {
                      if (widget.item != null) {
                        final String watt = wattController.text;
                        final int hrs = hrController.text.isNotEmpty
                            ? double.parse(hrController.text).toInt()
                            : 4;
                        final int qty = itemController.text.isNotEmpty
                            ? double.parse(itemController.text).toInt()
                            : 4;
                        try {
                          final newItem = ItemBrain(
                              load: widget.item!.load,
                              unitPower: double.parse(watt).toInt(),
                              dailyUsage: hrs,
                              qty: qty);
                          process.edditLoad(widget.item!, newItem);
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      } else if (itemController.text.isNotEmpty && wattController.text.isNotEmpty) {
                        final String watt = wattController.text;
                        final int hrs = hrController.text.isNotEmpty
                            ? double.parse(hrController.text).toInt()
                            : 4;
                        try {
                          final item = ItemBrain(
                              load: itemController.text,
                              unitPower: double.parse(watt).toInt(),
                              dailyUsage: hrs);
                          if (widget.isSetting) {
                            Db.saveItem(item: item);
                          } else {
                            process.addToLoad(item);
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                  )

                  /*
                BuildBotton(
                  label: 'Finish',
                  onPress: () {
                    if (itemController.text.isNotEmpty && wattController.text.isNotEmpty) {
                      final String watt = wattController.text;
                      try {
                        final item =
                            ItemBrain(load: itemController.text, unitPower: double.parse(watt).toInt());
                        if (isSetting) {
                          Db.saveItem(item: item);
                        } else {
                          process.addToLoad(item);
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),

                     */
                  ),
            ),
          ],
        )
      ],
    );
  }
}

class PanelDialogeBox extends StatefulWidget {
  const PanelDialogeBox({Key? key}) : super(key: key);

  @override
  State<PanelDialogeBox> createState() => _PanelDialogeBoxState();
}

class _PanelDialogeBoxState extends State<PanelDialogeBox> {
  final TextEditingController _searchController = TextEditingController();
  bool isClimate = true;
  List searchItems = [];

  _searchLoads(String text, List<Panel> panelBank) {
    final searchResult =
        panelBank.where((i) => i.w.toString().contains(text.toLowerCase())).toList();
    final result = {...searchResult}.toList();
    setState(() {
      searchItems = result;
    });
  }

//
  @override
  void initState() {
    Db.readObjectList(Panel.id, context);
    //
    if (isClimate) {
      searchItems = climateBank;
    } else {
      final process = Provider.of<Processor>(context, listen: false);
      searchItems = process.allPanels;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final process = Provider.of<Processor>(context);
    Widget climateCard() {
      Widget data = ListView.builder(
        //shrinkWrap: true,
        itemCount: searchItems.length, //searchItems.length,
        itemBuilder: (context, index) {
          final Climate item = searchItems[index];
          String location = item.locations.join('| ');
          return Card(
            //
            child: ListTile(
              title: Text(item.area),
              subtitle: Text(location),
              trailing: Text('${item.psh}phs'),
              onTap: () {
                setState(() {
                  searchItems = process.allPanels;
                  isClimate = false;
                });
                process.calculatePvModelsPW(region: item.psh);
                //
              },
            ),
          );
        },
      );
      return data; //
    }

    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isClimate
                        ? const Text(
                            'Select your region',
                            style: TextStyle(fontSize: 12),
                          )
                        : TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: (String v) {
                              _searchLoads(v, process.allPanels);
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
                  height: 300,
                  child: isClimate
                      ? climateCard()
                      : ListView.builder(
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
                                  process.calculatePvNumbers(spv: item);
                                  Navigator.pop(context);
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
        ),
      ),
    );
  }
}

// Load B3 Dialoge
class B3DialogBox extends StatefulWidget {
  const B3DialogBox({
    Key? key,
  }) : super(key: key);

  @override
  State<B3DialogBox> createState() => _B3DialogBoxState();
}

//
class _B3DialogBoxState extends State<B3DialogBox> {
  Battery? selectedItem;
//
  @override
  void initState() {
    super.initState();
    Db.readObjectList(Battery.id, context);
  }
  /*

  _searchLoads(String text, List<Battery> allItems) {
    final searchResult =
        allItems.where((i) => i.ah.toString().contains(text.toLowerCase())).toList();
    final result = {...searchResult}.toList();
    setState(() {
      // searchItems = result;
    });
  }

   */

//
  @override
  Widget build(BuildContext context) {
    final process = Provider.of<Processor>(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select your preferred Battery',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                //
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  /*
                  searchItems.length > 30
                      ? 300
                      : searchItems.length >= 2
                          ? searchItems.length * 100 - 100
                          : searchItems.length * 100,

                       */
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: process.allBattery.length, //searchItems.length,
                    itemBuilder: (context, index) {
                      final Battery item = process.allBattery[index];
                      return Card(
                        child: ListTile(
                          title: Text('${item.ah.toString()}ah'),
                          subtitle: Text(item.name),
                          trailing: Text('${item.volt}v'),
                          onTap: () {
                            process.calculateB3Size(sB3: item);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditAppliance extends StatefulWidget {
  const EditAppliance({Key? key}) : super(key: key);

  @override
  State<EditAppliance> createState() => _EditApplianceState();
}

class _EditApplianceState extends State<EditAppliance> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
