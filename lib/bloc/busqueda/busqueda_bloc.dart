import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'busqueda_event.dart';

part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState()) {
    // on<BusquedaEvent>((event, emit) {});
    on<OnActivarMarcadorManual>(
        (event, emit) => emit(state.copyWith(seleccionManual: true)));

    on<OnDesactivarMarcadorManual>(
        (event, emit) => emit(state.copyWith(seleccionManual: false)));

    on<OnAgregarHistorial>((event, emit) {
      final existe = state.historial
          .where(
              (element) => element.nombreDestino == event.result.nombreDestino)
          .length;

      if (existe == 0) {
        final newHistorial = [...state.historial, event.result];
        emit(state.copyWith(historial: newHistorial));
      }
    });
  }
}
