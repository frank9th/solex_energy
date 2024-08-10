import 'package:flutter/material.dart';

final List<String> topics = [
  'Energy',
  'Electricity',
  'Panels',
  'Battery',
  'Controller',
  'Inverter',
  'Resource',
];

final List<String> pdfFiles = [
  'assets/pdf/renewable_energy.pdf',
  'assets/pdf/02_basic_elect.pdf',
  'assets/pdf/04_solar_panel.pdf',
  'assets/pdf/07_battery.pdf',
  'assets/pdf/05_charge_control.pdf',
  'assets/pdf/06_inverter.pdf',
  'assets/pdf/03_solar_resource.pdf',
  'assets/pdf/08_cables.pdf',
];

class ContentScreen extends StatefulWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  var currentFunc;
  var activePage;
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
        onDrawerChanged: (val) {
          print(val);
          print('Drawal has chaged');
        },
        onEndDrawerChanged: (val) {
          print(val);
          print('Drawal has end ');
        },
        appBar: AppBar(
          title: const Text(
            'Solar Energy Guide',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.amber,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  )),
            ),

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
          ],
        ),
        /*
      drawer: Container(
        color: Colors.white,
        width: 100.0,
        child: ListView(
          children: [],
        ),
      ),

       */
        body: Container()

        /*
      Container(
        color: Colors.grey,
        height: MediaQuery.of(context).size.height, // Fixed height for the outer container
        child: Row(
          children: [
            Container(
              width: 90,
              color: containerColor,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.green[900],
                    child: SizedBox(
                      height: 100, // Fixed height for the first row
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/sl.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // BUTTONSQ
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 200,
                        color: Colors.amber,
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('TABLE'),
                        )),
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: topics.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ContainerButton(
                                  isActive: activePage == index ? true : false,
                                  lable: topics[index],
                                  onTap: () {
                                    setState(() {
                                      activePage = index;
                                      isOpened = !isOpened;
                                    });
                                  },
                                ),
                                const CustumDivider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isOpened ? MediaQuery.of(context).size.width - 100 : 0,
                color: containerColor?.withOpacity(0.7),
                child: isOpened ? PDFScreen(path: pdfFiles[activePage]) : const SizedBox.shrink()),
            Expanded(
              flex: 1,
              child: Container(
                  color: containerColor?.withOpacity(0.5),
                  //height: 400, // Fixed height for the right column
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Practical Guide to SOLAR ENERGY',
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),

           */
        );
  }
}

/*
class TableOfContents extends StatelessWidget {
  const TableOfContents({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table of Contents'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(topics[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(path: pdfFiles[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String path;

  const PDFScreen({super.key, required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset(
        widget.path,
      ),
    );
  }
}

 */
