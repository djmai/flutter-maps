part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  const MarcadorManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  const _BuildMarcadorManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Boton regresar
        Positioned(
          top: 39,
          left: 30,
          child: FadeInLeft(
            duration: Duration(milliseconds: 150),
            child: CircleAvatar(
              maxRadius: 23,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  context
                      .read<BusquedaBloc>()
                      .add(OnDesactivarMarcadorManual());
                },
              ),
            ),
          ),
        ),

        Center(
          child: Transform.translate(
            offset: Offset(0, -15),
            child: BounceInDown(
              from: 200,
              child: Icon(
                Icons.location_on,
                color: Colors.black87,
                size: 40,
              ),
            ),
          ),
        ),

        // Botón confirmar destino
        Positioned(
          bottom: 30,
          left: 40,
          child: FadeInUp(
            child: MaterialButton(
              minWidth: width - 120,
              child: Text('Confirmar destino',
                  style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                this.calcularDestino(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);

    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    // Obtener información del destino
    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino!);

    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio!, destino);

    final geometry = drivingResponse.routes![0].geometry;
    final duracion = drivingResponse.routes![0].duration;
    final distancia = drivingResponse.routes![0].distance;
    final nombreDestino = reverseQueryResponse.features![0].text;

    // Decodificar los puntos de geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaCoords =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoords, distancia!, duracion!, nombreDestino!));

    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnDesactivarMarcadorManual());

    //  Agregar al historial
    final busquedaBloc = context.read<BusquedaBloc>();
    final result = SearchResult(
      cancelo: false,
      destino: destino,
      nombreDestino: nombreDestino,
      descripcion: reverseQueryResponse.features![0].placeNameEs,
    );
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
