import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solex/model.dart';

import '../data.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  @override
  void initState() {
    super.initState();
    Db.readObjectList(ItemBrain.id, context);
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> tableData() {
      final process = Provider.of<Processor>(context);
      List<ItemBrain> houseLoad = process.houseLoad;
      var data = [
        //TABLE HEADER
        const TableRow(
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            //color: Colors.green.withOpacity(0.5),
            // borderRadius: BorderRadius.circular(10),
          ),
          children: [
            TableHeadCell(
              label: 'LOADS',
            ),
            TableHeadCell(
              label: 'QTY',
            ),
            TableHeadCell(
              label: 'uNIT (W)',
            ),
            TableHeadCell(
              label: 'Hw',
            ),
          ],
        ),
      ];

      //
      for (var i in houseLoad) {
        data.add(
          TableRow(
            children: [
              /*
              TableCellData(
                text: index.toString(),
              ),

               */
              TableCellData(
                text: i.load,
              ),
              TableCellData(
                text: i.qty.toString(),
              ),
              TableCellData(
                text: i.unitPower.toString(),
              ),
              //  TableCell(child: Center(child: Text('Row 1, Col 5'))),
              TableCellData(
                text: i.dailyUsage.toString(),
              ),

              // TableCell(child: Center(child: Text('Row 1, Col 7'))),
            ],
          ),
        );
      }
      return data;
    }

//
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Table(

            //border: TableBorder.all(color: Colors.black45),
            border: TableBorder.symmetric(
              outside: BorderSide.none,
              inside: const BorderSide(width: 1, color: Colors.white54, style: BorderStyle.solid),
            ),
            columnWidths: const {
              //0: FlexColumnWidth(0.4), // 1st column
              1: FlexColumnWidth(0.5),
              3: FlexColumnWidth(0.5),
              4: FlexColumnWidth(0.5), // 3rd column
            },
            children: tableData()),
      ),
    );
  }
}

class TableCellData extends StatelessWidget {
  final String text;
  const TableCellData({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      color: Colors.amberAccent, // Body cell color
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      )),
    ));
  }
}

class TableHeadCell extends StatelessWidget {
  final String label;
  const TableHeadCell({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
