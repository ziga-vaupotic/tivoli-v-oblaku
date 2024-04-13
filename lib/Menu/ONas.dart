import 'dart:ui';

import 'package:flutter/material.dart';

class ONas extends StatefulWidget {
  ONas({Key key}) : super(key: key);

  @override
  _ONasState createState() => _ONasState();
}


class _ONasState extends State<ONas> {
  

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text("O nas"),
        ),
        body: Container(child: SingleChildScrollView( 

        child: Column(  children: [ 
          Image(image: AssetImage("assets/menu_assets/logo.png")),
          Text(" O aplikaciji: ", style: new TextStyle(fontSize: 30), textAlign: TextAlign.center),
          SizedBox(height: 15),
          Text('Aplikacija je bila narejena znotraj projekta "Zaupajmo v lastno ustvarjalnost". Ime "Tivoli v oblaku" je dobila po temi projekta, ki je spoznavanje dendrologije v parku Tivoli. ', style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.left),
          SizedBox(height: 15),
          Text("  Ekipa:", style: new TextStyle(fontSize: 30), textAlign: TextAlign.center,),
          SizedBox(height: 15),
          Text('IT: Žiga Vaupotič, Oskar Rotar\nUrejanje baze podatkov: Lucija Rotar, Tian Vesel\nIT Mentor: mag. Dušan Pecek\nStrokovni mentorici: mag. Darja Silan, prof. Simona Granfol', style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.left),
          ], )
        ),
        alignment: Alignment.centerLeft, margin: EdgeInsets.only(left: 10.0, right: 20.0),),
    );
  }
}
