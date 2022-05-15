//import 'dart:html';

import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:project_tivoli/Utilities/Globals.dart';
import 'package:sqflite/sqflite.dart';

import '../Utilities/Map.dart';
import '../Utilities/SQLParser.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';
import '../Databases/RetriveDataFromSQL.dart';
import '../Databases/ExportSQL.dart';
import 'package:location/location.dart';
import 'TreeInfo.dart';

import 'dart:math';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> markersList = HashSet<Marker>();
  GoogleMapController mapController;
  Location loc = Location();

  List<int> m_lTreeList = [];


  final getUserDB = DatabaseExporter.instance;
  final getInfoFromDb = GetInfoFromDB.instance;

  static bool m_bIsDistance10mBackup = true;
  bool doOnce = false;


  void getAllTrees() 
  {
    List<SQLParser> m_pSortedList = getInfoFromDb.kor;
    m_pSortedList.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    m_pSortedList.forEach((element) {
      m_lTreeList.add(getInfoFromDb.kor.indexOf(element));
    });

  }

  double curbestDist = 20;
  LatLng lastLocalPos = new LatLng(0, 0);

  int bestIndex(double llat, double llong) {
    double bestdist = 324242;
    var bestindex = 0;
    getInfoFromDb.kor.forEach((element) => 
    {
        if (calculateDistance(llat, llong, element.lat, element.long) < bestdist)
        {
            bestdist = calculateDistance(llat, llong, element.lat, element.long),
            bestindex = getInfoFromDb.kor.indexOf(element)
        }
    });
    curbestDist = bestdist;
    return bestindex;
  }

  bool isDistanceTenMeters() {
    if (curbestDist < 0.010)
      return true;
    else
      return false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getAllTrees();  

    loc.onLocationChanged.listen((l) {
      lastLocalPos = new LatLng(l.latitude, l.longitude);
      int iBestIndex = bestIndex(l.latitude, l.longitude);
      if(isDistanceTenMeters())
      {
        getUserDB.updateTrees(getInfoFromDb.kor[iBestIndex].idDrevesa);
        if(m_bIsDistance10mBackup == false)
        {
            setState(() { 
          });
        }
      }

      if(!isDistanceTenMeters() && m_bIsDistance10mBackup)
      {
        setState(() { 
          });
      }

      m_bIsDistance10mBackup = isDistanceTenMeters();

      if(!doOnce){
                setState(() { 
          });
        doOnce = true;
      }

    });

    setState(() {
      getInfoFromDb.kor.forEach((element) => {
            markersList.add(Marker(
                markerId: MarkerId(element.index.toString()),
                position: LatLng(element.lat, element.long),
                infoWindow: InfoWindow(title: element.name,
                onTap: () => { 
                  mapController.isMarkerInfoWindowShown(MarkerId(element.index.toString())).then((value) {
                    if(value == true)
                    {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TreeInfo(getInfoFromDb.kor.indexOf(element), lastLocalPos)),
                    );
                    }
                  })
                },)))
          });

    });
  }


  Widget cardWidget(int m_iItem) {

    TextStyle m_pText = TextStyle(color: m_pTextColor);
    return OutlineButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getInfoFromDb.kor[m_iItem].name, style: m_pText),
          if(lastLocalPos != LatLng(0,0))
            Text(calculateDistance(lastLocalPos.latitude, lastLocalPos.longitude, getInfoFromDb.kor[m_iItem].lat, getInfoFromDb.kor[m_iItem].long).toStringAsFixed(2) + " km", style: m_pText,) 
        ],
      ),
      onPressed: () => {
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition (target: LatLng(getInfoFromDb.kor[m_iItem].lat, getInfoFromDb.kor[m_iItem].long), zoom: 17))),
        mapController.showMarkerInfoWindow(MarkerId(getInfoFromDb.kor[m_iItem].index.toString())),
      },
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Zemljevid z drevesi'),
          toolbarHeight: 40,
        ),
        body:Column( 
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                height: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.satellite,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(46.0525447, 14.4926662),
                    zoom: 14,
                  ),
                  markers: markersList,
                  ),
              ),
              SizedBox(// or use fixed size like 200
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width - 75,
                child: Container(
                  child: SingleChildScrollView( 
                    child: Column(
                    children: m_lTreeList.map((item) => cardWidget(item)).toList(),
                  ),
                  
                  ),
                  color: m_pBackGroundColor,
                ),
              
              ),
            ],
          
        ),
        floatingActionButton: new Visibility(
          visible: isDistanceTenMeters(),
          child:
            FloatingActionButton(
              backgroundColor: Colors.blueGrey.withOpacity(1),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TreeInfo(
                        bestIndex(lastLocalPos.latitude, lastLocalPos.longitude), lastLocalPos))),
              child: Icon(Icons.nature_people),
        ))
      );
  }
}
