import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'buildButton.dart';

class MultiColorContainer extends StatefulWidget {
  final String? text;
  final Function() onPress;
  final Widget? child;
  final bool hasIcon;
  const MultiColorContainer(
      {Key? key, required this.text, required this.onPress, this.hasIcon = false, this.child})
      : super(key: key);

  @override
  State<MultiColorContainer> createState() => _MultiColorContainerState();
}

class _MultiColorContainerState extends State<MultiColorContainer> {
  final Random _random = Random();
  Color _color = Colors.blue;

  Timer? _colorTimer;

  @override
  void initState() {
    super.initState();
    _startColorTimer();
  }

  void _startColorTimer() {
    _colorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _color = Color.fromRGBO(
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
          1,
        );
      });
    });
  }

  @override
  void dispose() {
    _colorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child != null
        ? Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(50)),
            child: widget.child,
          )
        : buildButton(
            widget.text!,
            textColor: Colors.white,
            bgColor: _color,
            onPress: widget.onPress,
            hasIcon: widget.hasIcon,
          );
  }
}
