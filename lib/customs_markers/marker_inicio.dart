import 'package:flutter/material.dart';

class MarkerInicioPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;

    Paint paint = Paint()..color = Colors.black;

    //  Dibujar un circulo negro
    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR),
      20,
      paint,
    );

    //  Dibujar un circulo blanco
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR),
      circuloBlancoR,
      paint,
    );
  }

  @override
  bool shouldRepaint(MarkerInicioPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerInicioPainter oldDelegate) => false;
}
