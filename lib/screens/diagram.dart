import 'package:flutter/material.dart';

class PVSystemDiagram extends StatelessWidget {
  const PVSystemDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PV System Diagram'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(400, 300), // Adjust size as needed
          painter: DiagramPainter(),
        ),
      ),
    );
  }
}

class DiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw solar panels
    canvas.drawRect(Rect.fromLTWH(50, 50, 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(200, 50, 100, 100), paint);

    // Draw charge controller
    canvas.drawCircle(Offset(175, 150), 10, paint);

    // Draw inverter
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(300, 50, 50, 100), Radius.circular(10)), paint);

    // Draw battery
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(300, 200, 50, 100), Radius.circular(10)), paint);

    // Draw connections
    paint
      ..strokeWidth = 1.0
      ..color = Colors.blue;
    canvas.drawLine(Offset(150, 100), Offset(175, 140), paint); // Panel 1 to charge controller
    canvas.drawLine(Offset(250, 100), Offset(175, 140), paint); // Panel 2 to charge controller
    canvas.drawLine(Offset(185, 150), Offset(300, 100), paint); // Charge controller to inverter
    canvas.drawLine(Offset(185, 150), Offset(300, 250), paint); // Charge controller to battery
    canvas.drawLine(Offset(350, 100), Offset(350, 150), paint); // Inverter to battery
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
