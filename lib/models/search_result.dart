import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool cancelo;
  final bool? manual;
  final LatLng? destino;
  final String? nombreDestino;
  final String? descripcion;

  SearchResult({
    required this.cancelo,
    this.manual,
    this.destino,
    this.nombreDestino,
    this.descripcion,
  });
}
