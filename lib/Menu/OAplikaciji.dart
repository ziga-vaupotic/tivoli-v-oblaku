import 'dart:ui';

import 'package:flutter/material.dart';

class OAplikaciji extends StatefulWidget {
  OAplikaciji({Key key}) : super(key: key);

  @override
  _OAplikacijiState createState() => _OAplikacijiState();
}


class _OAplikacijiState extends State<OAplikaciji> {
  

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text("O nas"),
        ),
        body: Text("Ob kliku na 'Zemljevid z drevesi'")
    );
  }
}
