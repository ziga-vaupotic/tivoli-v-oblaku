import 'package:project_tivoli/Menu/Kviz/schoolQuestions.dart';
import 'package:project_tivoli/Menu/Kviz/schoolWidget.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../main.dart';
import 'dart:async';
import 'dart:math';
import 'KvizEnd.dart';
import 'dart:collection';
import '../../Databases/QuizAnswer.dart';
import '../../Databases/RetriveDataFromSQL.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "StartPage.dart";

const int cMAXQUESTIONS = 10;

class SchoolKviz extends StatefulWidget {
  const SchoolKviz({Key key}) : super(key: key);

  @override
  _SchoolKvizState createState() => _SchoolKvizState();
}

class _SchoolKvizState extends State<SchoolKviz> {
  List<String> lQuestionsToPass = [];
  Set<Marker> markersList = HashSet<Marker>();
  GoogleMapController mapController;
  int iIndex = 0;
  int iTreeIndex = 0;
  final m_pDatabaseManager = QuizExporter.instance;
  final getInfoFromDb = GetInfoFromDB.instance;
  Database m_pDatabase;

  int maxQuestions(int iLenght) {
    if (iLenght > cMAXQUESTIONS) {
      return cMAXQUESTIONS;
    } else {
      return iLenght;
    }
  }

  void getRandomTreeIndex() 
  {
    var iRng = new Random();
    iTreeIndex = int.parse(getInfoFromDb.kor[iRng.nextInt(getInfoFromDb.kor.length)].idDrevesa);

    markersList.add(
      Marker(
        markerId: MarkerId(getInfoFromDb.kor[iRng.nextInt(getInfoFromDb.kor.length)].index.toString()),
        position: LatLng(getInfoFromDb.kor[iRng.nextInt(getInfoFromDb.kor.length)].lat, getInfoFromDb.kor[iRng.nextInt(getInfoFromDb.kor.length)].long),
        infoWindow: InfoWindow(title: getInfoFromDb.kor[iRng.nextInt(getInfoFromDb.kor.length)].name),
    ));

  }

  void selectRandomQuestions() {
    print( maxQuestions(lSchoolQuestions.length - 1));
    for (int i = 0; i < maxQuestions(lSchoolQuestions.length - 1); i++) {
      var iRng = new Random();
      String pCurrentQuestion = lSchoolQuestions[iRng.nextInt(lSchoolQuestions.length - 1)];
      if (lQuestionsToPass.contains(pCurrentQuestion)) {
        i--;
        continue;
      }

      lQuestionsToPass.add(pCurrentQuestion);
    }
    print(lQuestionsToPass.length);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
    });
  }
  

  @override
  void initState() {
    super.initState();
    markersList = HashSet<Marker>();
    getRandomTreeIndex();
    m_pDatabaseManager.setDatabaseToNull();
    selectRandomQuestions();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column( 
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,  // or use fixed size like 200
              height: MediaQuery.of(context).size.height / 2,
              child: QuestionsWidget(
                callback: callBack,
                vprasanje: lQuestionsToPass[iIndex]
              ),
            ),
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
                    zoom: 16,
                  ),
                  markers: markersList,
              ),
            ),
          ],
        ),
    );
  }

  void callBack(String answer) {
    m_pDatabaseManager.addQuizAnswer(m_pDatabaseManager.db, iTreeIndex, answer, lQuestionsToPass[iIndex]);
    iIndex++;
    if (iIndex >= (lQuestionsToPass.length)) 
    {
      Navigator.pop(context);
      return;
    }

    setState(() {
      
    });
  
  }
}
