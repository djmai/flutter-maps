import 'package:flutter/material.dart';

import 'package:mapa_app/helpers/helpers.dart';
import 'package:mapa_app/pages/acceso_gps.dart';
import 'package:mapa_app/pages/mapa_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (context, snapshot) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
      ),
    );
  }

  Future checkGpsYLocation(BuildContext context) async {
    //  TODO: PermisoGPS
    //  TODO: GPS está activo

    await Future.delayed(Duration(milliseconds: 1000));

    Navigator.pushReplacement(context, navegarMapaFadeIn(context, AccesoGpsPage()));
    // Navigator.pushReplacement(context, navegarMapaFadeIn(context, MapaPage()));
  }
}
