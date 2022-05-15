import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import '../../Databases/RetriveDataFromSQL.dart';

class AnswersFromDB extends StatefulWidget {
  final String m_strPath;
  
  const AnswersFromDB(this.m_strPath); 

  @override
  _AnswersFromDBState createState() => _AnswersFromDBState();
}



class _AnswersFromDBState extends State<AnswersFromDB> {



  List<Map<String, dynamic>> m_pRows = [];
  Set<Marker> markersList = HashSet<Marker>();
  GoogleMapController mapController;
  final getInfoFromDb = GetInfoFromDB.instance;

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    var m_pDirectory = await getApplicationDocumentsDirectory();
    var m_pDir = new Directory(m_pDirectory.path + "/kviz_answers/" + widget.m_strPath.split("/kviz_answers/").last.substring(0, widget.m_strPath.split("/kviz_answers/").last.length - 1));
    print(m_pDir.path);
    Database db = await openDatabase(
      m_pDir.path,
      version: 1,
    );
    m_pRows = await db.query("quiz");
    print("Rows" + m_pRows.length.toString());


    getInfoFromDb.kor.forEach((element) 
    {
      if(element.idDrevesa == m_pRows.elementAt(m_pRows.length - 1)['TreeID'].toString())
      {
        markersList.add(
          Marker(
            markerId: MarkerId("2"),
            position: LatLng(element.lat, element.long),
          )
        );
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    markersList = HashSet<Marker>();
    super.initState();
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  Widget buildRoundedCard(String question, String answer) {
    return Card(
      //margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 2.0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(question, style: TextStyle(fontSize: 18)),
            Text("Odgovor: " + answer, style: TextStyle(fontSize: 14))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: querryAllRows(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Container();
          }
          else 
          {
            return Scaffold(
              body: Column( 
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                    height: MediaQuery.of(context).size.height / 2,
                    child:
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        mapType: MapType.satellite,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        mapToolbarEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(markersList.elementAt(markersList.length - 1).position.latitude, markersList.elementAt(markersList.length - 1).position.longitude),
                          zoom: 14,
                        ),
                        markers: markersList,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView( 
                      child: Container(
                        child: Column(
                          children: m_pRows.map((e) => buildRoundedCard(e['Question'].toString(), e['Odgovor'].toString())).toList(),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }
}

