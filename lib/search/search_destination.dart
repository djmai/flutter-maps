import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_app/models/search_response.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:mapa_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;

  SearchDestination(this.proximidad)
      : searchFieldLabel = 'Buscar',
        _trafficService = TrafficService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => this.query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final searchResult = SearchResult(cancelo: true);
    return IconButton(
      onPressed: () => this.close(context, searchResult),
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicación manualmente'),
            onTap: () {
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          )
        ],
      );
    }

    return _construirResultadosSugerencias();
  }

  Widget _construirResultadosSugerencias() {
    if (this.query.length == 0) {
      return Container();
    }

    this._trafficService.getSugerenciasPorQuery(query.trim(), proximidad);

    return StreamBuilder(
      stream: _trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final lugares = snapshot.data!.features;

        if (lugares!.length == 0) {
          return ListTile(
            title: Text('No hay resultados con $query'),
          );
        }

        return ListView.separated(
          separatorBuilder: (_, i) => Divider(),
          itemCount: lugares.length,
          itemBuilder: (_, i) {
            final lugar = lugares[i];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(lugar.textEs!),
              subtitle: Text(lugar.placeNameEs!),
              onTap: () {
                this.close(
                    context,
                    SearchResult(
                        cancelo: false,
                        manual: false,
                        destino: LatLng(lugar.center![1], lugar.center![0]),
                        nombreDestino: lugar.textEs,
                        descripcion: lugar.placeNameEs));
              },
            );
          },
        );
      },
    );
  }
}
