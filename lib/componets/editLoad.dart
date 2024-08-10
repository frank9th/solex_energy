import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../model.dart';

class EditLoad extends StatelessWidget {
  final bool qty;
  final bool watt;
  final bool time;
  final bool isCable;
  final ItemBrain? item;
  const EditLoad(
      {Key? key,
      this.qty = false,
      this.watt = false,
      this.time = false,
      this.isCable = false,
      this.item})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final brain = Provider.of<Processor>(context);
    String edited = '';
    ItemBrain load = item != null ? item! : brain.getLastLoad();
    String tittle = '';
    String text = '';
    if (qty) {
      tittle = 'How many ${load.load}?';
      text = load.qty.toString();
    } else if (watt) {
      tittle = item != null ? '${item!.load} (w)' : 'How many Watt (w)?';
      text = load.unitPower.toString();
    } else if (time) {
      tittle = 'How many Hours (Wh)';
      text = load.dailyUsage.toString();
    } else if (isCable) {
      tittle = 'Enter cable length in feet eg. 5';
    }
    return AlertDialog(
      title: Center(
        child: Text(
          tittle,
          style: const TextStyle(fontSize: 13),
        ),
      ),
      content: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          edited = value;
        },
        controller: TextEditingController(text: text),
        autofocus: true,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (item != null) {
              String docName = ItemBrain.id;
              String collName = item!.load;
              Db.deleteEntries(collName: collName, docName: docName);
            }
            Navigator.of(context).pop();
          },
          child: Text(item != null ? 'Delete' : 'Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (edited.isNotEmpty) {
              // Write save method here
              try {
                if (qty) {
                  load =
                      ItemBrain(load: load.load, unitPower: load.unitPower, qty: int.parse(edited));
                } else if (watt) {
                  load = ItemBrain(load: load.load, unitPower: int.parse(edited), qty: load.qty);
                } else if (time) {
                  load = ItemBrain(
                      load: load.load,
                      unitPower: load.unitPower,
                      qty: load.qty,
                      dailyUsage: int.parse(edited));
                }
                if (isCable) {
                  try {
                    brain.calculateCable(len: int.parse(edited));
                  } catch (e) {}
                } else {
                  if (item != null) {
                    Db.saveItem(item: load);
                  } else {
                    brain.editLastLoad(load);
                  }
                }
              } catch (e) {}

              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
