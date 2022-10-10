part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration(milliseconds: 300),
            child: _buildSearchBar(context),
          );
        }
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
            final historial = context.read<BusquedaBloc>().state.historial;
            final SearchResult? resultado = await showSearch(
              context: context,
              delegate: SearchDestination(proximidad!, historial),
            );
            retornoBusqueda(context, resultado!);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity,
            child: Text('¿Dónde quieres ir?',
                style: TextStyle(color: Colors.black87)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    if (result.manual!) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);

    // Calcular la ruta en base al valor: Result
    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.destino;

    // Obtener información del destino
    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino!);

    final drivingTraffic =
        await trafficService.getCoordsInicioYFin(inicio!, destino);

    final geometry = drivingTraffic.routes![0].geometry;
    final duration = drivingTraffic.routes![0].duration;
    final distance = drivingTraffic.routes![0].distance;
    final nombreDestino = reverseQueryResponse.features![0].text;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((points) => LatLng(points[0], points[1]))
        .toList();

    mapaBloc
        .add(OnCrearRutaInicioDestino(rutaCoordenadas, distance!, duration!, nombreDestino!));

    // Mover camara al destino
    mapaBloc.moverCamara(destino);

    Navigator.of(context).pop();

    //  Agregar al historial
    final busquedaBloc = context.read<BusquedaBloc>();
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
