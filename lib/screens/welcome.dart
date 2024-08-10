import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Solar App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png', // Replace 'logo.png' with your actual logo file
              width: 150, // Adjust size as needed
              height: 150, // Adjust size as needed
            ),
            SizedBox(height: 20),
            Text(
              'Estimate Your Solar Potential',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Calculate Your Savings',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the solar calculator screen
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
