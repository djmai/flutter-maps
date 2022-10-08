import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import 'package:mapa_app/themes/uber_map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';

part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState()) {
    on<MapaEvent>((event, emit) {});
  }

  GoogleMapController? _mapController;

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController!.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  void onEvent(MapaEvent event) {
    super.onEvent(event);
    print('onEvent');
    if (event is OnMapaListo) {
      state.copyWith(mapaListo: true);
      print('Mapa Listo');
    }
    print(event);
  }

// @override
// void onChange(Change<MapaState> change) {
//   super.onChange(change);
//   print('onChange');
//   print(change);
// }
//
// @override
// void onTransition(Transition<MapaEvent, MapaState> transition) {
//   super.onTransition(transition);
//   print('onTransition');
//   print(transition);
// }
//
// @override
// void onError(Object error, StackTrace stackTrace) {
//   print('onError');
//   print('$error, $stackTrace');
//   super.onError(error, stackTrace);
// }
}
