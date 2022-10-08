import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mi_ubicacion_event.dart';

part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState()) {
    on<MiUbicacionEvent>((event, emit) => emit(ubicacionCambio(event)));
  }

  StreamSubscription<Position>? _positionSubscription;

  void iniciarSeguimiento() async {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: settings)
            .listen((Position position) {
      final nuevaUbicacion = LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(nuevaUbicacion));
    });

    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  void cancelarSeguimiento() {
    _positionSubscription?.cancel();
  }

  @override
  void onEvent(MiUbicacionEvent event) {
    super.onEvent(event);
    print('onEvent');
    print(event);
  }

  @override
  void onChange(Change<MiUbicacionState> change) {
    super.onChange(change);
    print('onChange');
    print(change);
  }

  @override
  void onTransition(Transition<MiUbicacionEvent, MiUbicacionState> transition) {
    super.onTransition(transition);
    print('onTransition');
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('onError');
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  ubicacionCambio(MiUbicacionEvent event) {
    if (event is OnUbicacionCambio) {
      return state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion);
    }
  }
}
