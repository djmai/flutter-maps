import 'dart:async';

import 'package:bloc/bloc.dart';
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
  }
}
