import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BluetoothOffScreen.dart';
import 'FindDevicesScreen.dart';

// Inicio do aplicativo

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //Orientaçao do dispositivo: para cima (nao eh possivel "deitar" o celular)
    ]);
    return MaterialApp(
      title: "Se conecte ao bebê", //Titulo
      debugShowCheckedModeBanner: false, //Tira o banner do debug
      color: Colors.blueAccent,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown, //inicialmente o estado do bluetooth eh desconhecido
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {  // se bluetooth estiver ligado no dispositivo, entao vai para o arquivo FindDevicesScreen.dart
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state); // se o bluetooth nao estiver ligado, entao vai para o arquivo
            // BluetoohOffScreen.dart ateh que o usuario ligue o bluetooth.
            // Quando ativar, vai para FindDevicesScreen.dart
          }),
    );

  }
}