import 'package:flutter/material.dart';

class BuildBotton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final Function()? onPress;
  const BuildBotton(
      {Key? key,
      this.bgColor = Colors.white,
      this.textColor = Colors.black,
      this.onPress,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(bgColor)),
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }
}

Widget buildButton(String label,
    {Color bgColor = Colors.white,
    Color textColor = Colors.black,
    Function()? onPress,
    bool hasIcon = false}) {
  return ElevatedButton(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(bgColor)),
    onPressed: onPress,
    child: hasIcon
        ? Row(
            children: [
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_forward,
                weight: 8.0,
                color: textColor,
                size: 18,
              )
            ],
          )
        : Text(
            label,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
  );
}
