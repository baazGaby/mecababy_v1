// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

//Auxilia FindDevicesScreen.dart para escanear os dispositivos disponiveis para conectar

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start, //posiçao do children (no caso, Text): em cima e na esquerda
        crossAxisAlignment: CrossAxisAlignment.start, //Alinha a borda esquerda de children ao
                                                        // longo da borda esquerda da coluna
        children: <Widget>[
          Text(
            result.device.name,  //nome do dispositivo
            overflow: TextOverflow.ellipsis, //Se o nome do bluetooth for muito grande, vai usar reticências
            style: TextStyle(fontSize: 15),
          ),

     //     Text(
     //        result.device.id.toString(),  //mostra o id do dispositivo
     //       style: Theme.of(context).textTheme.caption,
     //     )

        ],
      );
    } else {
      return Text(result.device.id.toString()); //mostra o id do dispositivo
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: null,
      title: _buildTitle(context), //retoma o _buildTitle()

      //BOTAO CONECTAR
      trailing: RaisedButton(
        child: Text('Conectar'),
        color: Colors.black, //cor botao
        textColor: Colors.white, //cor texto
        onPressed:
        (result.advertisementData.connectable)
            ? onTap
            : null,

      ),
    );
  }
}



