import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'TelaAbrir.dart';
import 'widgets.dart';

// Tela em que procura dispositivos para conectar por bluetooth
class FindDevicesScreen extends StatelessWidget {

final device;
const FindDevicesScreen({Key key, this.device}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //cor do fundo

      //Parte de cima da tela
      appBar: AppBar(
        title: Text('Escolha sua boneca'),
        backgroundColor: const Color(0xFFFFCBDB),
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)), //Começa a escanear os dispositivos por 4s

        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[

              StreamBuilder<List<BluetoothDevice>>( //Widget que se constrói com base nas informaçoes que recebe.
                                                    // No caso, eh sobre dispositivos que jah estao conectados
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
               children: snapshot.data
                      .map((d) => ListTile(
                    title: Text(d.name), //Aparece o nome do dispositivo
               //  subtitle: Text(d.id.toString()),
                 trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state, //estado do dispositivo
                      initialData: BluetoothDeviceState.connecting, //dados iniciais: o dispositivo esta conectando
                      builder: (c, snapshot) {
                        if (snapshot.data == BluetoothDeviceState.connected) { //se o celular jah estiver conectado cm um
                                                                               // dispositivo, aparecerá esse dispositivo na tela
                                                                               // como primeira opçao e com o botao escrito "abrir".
                                                                               // Ao clicar, vai para TelaAbrir.dart.
                          //BOTAO
                          return RaisedButton(
                            color: const Color(0xFF015D92), //cor botao
                            child: Text(' Abrir '),
                            textColor: Colors.white, //cor texto
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TelaAbrir(device: d))), //Manda a variavel d para TelaAbrir.dart
                          );
                        }

                          return Text(snapshot.data.toString());
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),

              StreamBuilder<List<ScanResult>>( //Aparece os resultados do escaneamento de dispositivos.
                                                // Utiliza widgets.dart para mostrar o nome dos
                                                // dispositivos e o botao de conectar.
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                          //Se apertado, conecta com o dispositivo e vai para TelaAbrir.dart
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect(); //conecta com o dispositivo
                            return TelaAbrir(device: r.device); //Manda a a variavel device para TelaAbrir.dart
                          })),


                    ),
                  )
                      .toList(),
                ),
              ),

            ],
          ),
        ),
      ),

//BOTAO QUE REINICIA O ESCANEAMENTO DOS DISPOSITIVOS DISPONIVEIS E TBM FAZ ELE PARAR
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) { //Enquanto esta escanenado, o botao eh vermelho cm o icone de parar.
                              // Ao ser clicado ele para de scanear.
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else { //Se nao estiver escaneando, o botao eh branco com o icone de lupa. Ao ser clicado, ele começa a escanear
            return FloatingActionButton(
                child: Icon(Icons.search, color: Colors.blueAccent),
                backgroundColor: Colors.white,
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}