import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSystemAnalysisActive = true;

  List<Map<String, dynamic>> devices = [
    {"name": "Fan", "quantity": 4, "unitWatt": 65, "hourlyUsage": 24},
    {"name": "TV 65 inch", "quantity": 1, "unitWatt": 200, "hourlyUsage": 4}
  ];

  void toggleAnalysis() {
    setState(() {
      isSystemAnalysisActive = !isSystemAnalysisActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                if (!isSystemAnalysisActive) toggleAnalysis();
              },
              child: Text('System Analysis'),
              style: ElevatedButton.styleFrom(
                primary: isSystemAnalysisActive ? Colors.blue : Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isSystemAnalysisActive) toggleAnalysis();
              },
              child: Text('Variable Analysis'),
              style: ElevatedButton.styleFrom(
                primary: !isSystemAnalysisActive ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('+ Add device'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            ...devices.map((device) => DeviceCard(device: device)).toList(),
            const Spacer(),
            ExpertOptions()
          ],
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;

  DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(device['name']),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: ${device['quantity']}'),
                Text('Unit watt (w): ${device['unitWatt']}'),
                Text('Hourly usage: ${device['hourlyUsage']} hrs'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpertOptions extends StatelessWidget {
  const ExpertOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Expert option Calculate for:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Battery size'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('PV Model'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cable size'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          children: [
            InfoTile(label: 'Total Power', value: '395 w'),
            InfoTile(label: 'Daily Energy', value: '5480 wh'),
            InfoTile(label: 'System Volt', value: '48 v'),
            InfoTile(label: 'Battery Cap', value: '167 Ah'),
            InfoTile(label: 'Battery Size', value: '0 Ah'),
            InfoTile(label: 'PV Model (WP)', value: '0 w'),
            InfoTile(label: 'Cable Size', value: '0 mm'),
            InfoTile(label: 'Inverter', value: '0 VA'),
            InfoTile(label: 'Parallel Conn', value: '0 PRc'),
            InfoTile(label: 'Series Conn', value: '0 SRc'),
            InfoTile(label: 'Charge Ctrl', value: '0 A'),
            InfoTile(label: 'Estimated Cost', value: '0 NGN'),
          ],
        ),
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(value),
          ],
        ),
      ),
    );
  }
}
