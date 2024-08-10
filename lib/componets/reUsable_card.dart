import 'package:flutter/material.dart';

class ReUsableCard extends StatelessWidget {
  const ReUsableCard(
      {super.key,
      required this.colour,
      required this.cardChild,
      this.onPress,
      this.height = 80.0,
      this.width = 80.0,
      this.margin = 5.0});
  final Color colour;
  final Widget cardChild;
  final double height;
  final double width;
  final double margin;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
      ),
      child: cardChild,
    );
  }
}
