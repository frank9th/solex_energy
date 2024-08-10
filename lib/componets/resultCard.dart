import 'package:flutter/material.dart';
import 'package:solex/componets/reUsable_card.dart';

import '../constants.dart';

class ResultCard extends StatelessWidget {
  final String label;
  final String text;
  final String symbol;
  final double height;
  final double width;
  final double margin;
  final bool hasColor;
  final Color color;
  const ResultCard({
    super.key,
    required this.label,
    this.text = '0',
    required this.symbol,
    this.height = 80.0,
    this.width = 100.0,
    this.margin = 5.0,
    this.hasColor = false,
    this.color = Colors.yellowAccent,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the container color based on the theme
    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850] // Dark theme color
        : Colors.grey[200];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color
    Color? cardShColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54 // Dark theme color
        : Colors.black; // Light theme color// Light theme color

    return ReUsableCard(
        width: width,
        height: height,
        margin: margin,
        colour: containerColor!, //hasColor ? color : Colors.black.withOpacity(0.2),
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text(label.toUpperCase(), style: TextStyle(fontSize: 10.0, color: cardShColor)),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //this places the cm at the base of the HERO NUMBER
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Center(
                    child: Text(
                      text.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: cardHColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Text(symbol,
                      style: TextStyle(fontSize: 10.0, color: cardShColor) //kLableTextStyle,
                      )
                ],
              ),
            ),

            //
          ],
        ));
  }
}
