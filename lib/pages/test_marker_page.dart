import 'package:flutter/material.dart';
import 'package:mapa_app/customs_markers/marker_inicio.dart';

class TestMarkerPage extends StatelessWidget {
  const TestMarkerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            painter: MarkerInicioPainter()
          ),
        ),
      ),
    );
  }
}
