import 'package:flutter/material.dart';

class EnergyCalculatorScreen extends StatefulWidget {
  const EnergyCalculatorScreen({super.key});

  @override
  _EnergyCalculatorScreenState createState() => _EnergyCalculatorScreenState();
}

class _EnergyCalculatorScreenState extends State<EnergyCalculatorScreen> {
  double powerConsumption = 0.0; // Initialize with default value
  double time = 0.0; // Initialize with default value

  double calculateEnergyConsumption() {
    // Implement your energy consumption calculation logic here
    // Example: energyConsumption = powerConsumption * time;
    return powerConsumption * time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Power Consumption (kW)',
              ),
              onChanged: (value) {
                setState(() {
                  powerConsumption = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Time (hours)',
              ),
              onChanged: (value) {
                setState(() {
                  time = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                final energyConsumption = calculateEnergyConsumption();
                // Show the result (e.g., in a dialog or another widget)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Energy Consumption'),
                    content: Text('$energyConsumption kWh'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}
