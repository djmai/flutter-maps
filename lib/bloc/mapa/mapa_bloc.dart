import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:geolocator/geolocator.dart';
import 'package:mapa_app/helpers/helpers.dart';
import 'package:meta/meta.dart';

import 'package:mapa_app/themes/uber_map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';

part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState()) {
    on<OnMapaListo>((event, emit) => emit(state.copyWith(mapaListo: true)));
    on<OnNuevaUbicacion>(_onNuevaUbicacion);
    on<OnMarcarRecorrido>(_onMarcarRecorrido);
    on<OnSeguirUbicacion>(_onSeguirUbicacion);
    on<OnMovioMapa>(_onMovioMapa);
    on<OnCrearRutaInicioDestino>(_onCrearRutaInicioDestino);
  }

  // Controlador del mapa
  GoogleMapController? _mapController;

  // Polyline Ruta
  Polyline _miRuta = Polyline(
    polylineId: PolylineId('mi_ruta'),
    color: Colors.transparent,
    width: 3,
  );

  // Polyline Ruta Destino
  Polyline _miRutaDestino = Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    color: Colors.black87,
    width: 3,
  );

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      _mapController = controller;
      _mapController!.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onNuevaUbicacion(OnNuevaUbicacion event, Emitter<MapaState> emit) {
    if (state.seguirUbicacion) {
      moverCamara(event.ubicacion);
    }

    List<LatLng> points = [..._miRuta.points, event.ubicacion];
    _miRuta = _miRuta.copyWith(pointsParam: points);

    final curretPolylines = state.polylines;
    curretPolylines['mi_ruta'] = _miRuta;

    emit(state.copyWith(polylines: curretPolylines));
  }

  void _onMarcarRecorrido(OnMarcarRecorrido event, Emitter<MapaState> emit) {
    if (!state.dibujarRecorrido) {
      _miRuta = _miRuta.copyWith(colorParam: Colors.black87);
    } else {
      _miRuta = _miRuta.copyWith(colorParam: Colors.transparent);
    }

    final curretPolylines = state.polylines;
    curretPolylines['mi_ruta'] = _miRuta;

    emit(state.copyWith(
      dibujarRecorrido: !state.dibujarRecorrido,
      polylines: curretPolylines,
    ));
  }

  void _onSeguirUbicacion(OnSeguirUbicacion event, Emitter<MapaState> emit) {
    if (!state.seguirUbicacion) {
      moverCamara(_miRuta.points[_miRuta.points.length - 1]);
    }
    emit(state.copyWith(seguirUbicacion: !state.seguirUbicacion));
  }

  void _onMovioMapa(OnMovioMapa event, Emitter<MapaState> emit) {
    emit(state.copyWith(ubicacionCentral: event.centroMapa));
  }

  void _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event, Emitter<MapaState> emit) async {
    _miRutaDestino =
        _miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = _miRutaDestino;

    // Icono inicio
    final iconoInicio = await getAssetImageMarker();
    final iconoDestino = await getNetworkImageMarker();

    // Marcadores
    final markerInicio = Marker(
      markerId: MarkerId('inicio'),
      position: event.rutaCoordenadas[0],
      icon: iconoInicio,
      infoWindow: InfoWindow(
        title: 'Mi Casa',
        snippet: 'Duración recorrido: ${(event.duracion / 60).floor()}',
      ),
    );

    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    final markerDestino = Marker(
      markerId: MarkerId('destino'),
      position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1],
      icon: iconoDestino,
      infoWindow: InfoWindow(
        title: event.nombreDestino,
        snippet:
            'Distancia: ${kilometros} Km',
      ),
    );

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerDestino;

    Future.delayed(Duration(milliseconds: 300)).then((value){
      _mapController!.showMarkerInfoWindow(MarkerId('destino'));
    });

    emit(state.copyWith(polylines: currentPolylines, markers: newMarkers));
  }
}
