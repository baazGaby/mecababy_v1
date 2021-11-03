import 'dart:convert' show utf8;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TelaAbrir extends StatefulWidget {
  final device;
  TelaAbrir ({Key key, this.device}) : super(key: key);

  @override
  _TelaAbrirState createState() => _TelaAbrirState(device);
}


class _TelaAbrirState extends State<TelaAbrir> {
  final device;
  _TelaAbrirState (this.device);
  BluetoothCharacteristic characteristic;
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b"; //identificador do serviço do esp32
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"; //identificador da caracteristica do esp32

  //#define SERVICE_UUID           "ab0828b1-198e-4351-b779-901fa0e0371e" // UART service UUID
  //#define CHARACTERISTIC_UUID_RX "4ac8a682-9736-4e5d-932b-e9b31405049c"

//widget que manda o valor "abrir" para o esp32 e entao muda de tela para TelaFechar.dart
  // eh utilizado quando o botao verde "destrancar porta" eh clicado
  Future<Widget> discoverServices(movimento) async {
    print('cccccc');

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) { //Se o service do esp32 que foi conectado agora for igual ao SERVICE_UUID.
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) { //Se o characteristic do esp32 que foi
                                                                        // conectado agora for igual ao CHARACTERISTIC_UUID.

            characteristic = characteristic;
            characteristic.write(utf8.encode(movimento)); //comando que envia o valor para esp32

          }
        });
      }
    });
  }


  //LAYOUT DA TELA
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () async => false, //Impede o usuario de voltar com a
                                      // setinha de voltar que jah tem no celular.

     child: Stack(
         //Criando a tela de fundo/
          children: <Widget>[

            //ICONE QUE MOSTRA SE O BLUETOOTH ESTÁ CONECTADO OU NÃO COM O CELULAR
            Container(
                alignment: AlignmentDirectional(-0.93,-0.75),
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: StreamBuilder<BluetoothDeviceState>(
                      stream: widget.device.state,
                      builder: (c, snapshot) {

                        if (snapshot.data == BluetoothDeviceState.connected) { //Se estiver conectado
                          return Icon(Icons.bluetooth_connected, color: Colors.white, size: 30.0,);
                        }

                        else{
                          return Icon(Icons.bluetooth_disabled, color: Colors.red, size: 30.0,);

                        }
                      }
                  ),
                )
            ),

            /*Botão para iniciar os movimentos*/
            Positioned(
              top:  (MediaQuery.of(context).size.height/2)-90,
              child: FlatButton(
                child: Container(
                  child: Text (
                    'Iniciar',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(8.0),
                ),
                onPressed: () async {
                  discoverServices('iniciar');
                },
              ),
            ),
            /*Botão para interromper os movimentos*/
            Positioned(
              top: (MediaQuery.of(context).size.height/2)+90,
              child: FlatButton(
                child: Container(
                  child: Text (
                    'Parar',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(8.0),
                ),
                onPressed: () async {
                  discoverServices('parar');
                },
              ),
            ),/*Botão para iniciar os movimentos*/
            Positioned(
              top:  (MediaQuery.of(context).size.height/2)-40,
              child: FlatButton(
                child: Container(
                  child: Text (
                    'Chupeta',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(8.0),
                ),
                onPressed: () async {
                  discoverServices('chupeta');
                },
              ),
            ),
            /*Botão para interromper os movimentos*/
            Positioned(
              top: (MediaQuery.of(context).size.height/2)+40,
              child: FlatButton(
                child: Container(
                  child: Text (
                    'Maxilar',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(8.0),
                ),
                onPressed: () async {
                  discoverServices('maxilar');
                },
              ),
            ),



        ]
    )
    );
  }

}
