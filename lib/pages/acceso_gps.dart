import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGpsPage extends StatefulWidget {
  const AccesoGpsPage({Key? key}) : super(key: key);

  @override
  State<AccesoGpsPage> createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Es necesario el GPS para usar esta app'),
          MaterialButton(
            child: Text(
              'Solicitar Acceso',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black,
            shape: StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () async {
              final status = await Permission.location.request();
              this.accesoGPS(status);
            },
          ),
        ],
      ),
    ));
  }

  void accesoGPS(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        openAppSettings();
        break;
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, 'mapa');
        break;
    }
  }
}
