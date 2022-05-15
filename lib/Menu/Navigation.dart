import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

import '../Utilities/Map.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';
import '../Databases/RetriveDataFromSQL.dart';
import '../Databases/ExportSQL.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'TreeInfo.dart';

class Navigation extends StatefulWidget {
  final LatLng m_pLocalPosition;
  final LatLng m_pMarkerPostion;

  const Navigation(this.m_pLocalPosition, this.m_pMarkerPostion);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  Set<Marker> markersList = HashSet<Marker>();
  GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> pLineCordinates = [];
  Set<Polyline> polylineSet = {};
  

  final getUserDB = DatabaseExporter.instance;
  final getInfoFromDb = GetInfoFromDB.instance;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  cretaePolyLine() {
    polylineSet.add(Polyline(polylineId: PolylineId('1'), color: Colors.blue, width: 3, points:pLineCordinates));
  }

  createMarker() {
      markersList.add(Marker(
          markerId: MarkerId("1"),
          position: widget.m_pMarkerPostion,
        )
      );
  }

  Future<void> getPolyLines() async {
    
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyCRNSilIOFS0v6tvLVgZ82zhjEDXthk6OQ",PointLatLng(widget.m_pLocalPosition.latitude, widget.m_pLocalPosition.longitude), 
    PointLatLng(widget.m_pMarkerPostion.latitude,widget.m_pMarkerPostion.longitude ), travelMode: TravelMode.walking);
    print(result.points);
    result.points.forEach((element) {
      pLineCordinates.add(LatLng(element.latitude, element.longitude));
    });
    await cretaePolyLine();
    await createMarker();
    return;
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPolyLines(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Container();
        }
        else 
        {
          return Scaffold(
              appBar: AppBar(
                title: Text('Zemljevid z drevesi'),
              ),
              body: GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: MapType.satellite,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: true,
                mapToolbarEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(46.0525447, 14.4926662),
                  zoom: 12,
                ),
                markers: markersList,
                polylines: polylineSet,
              ),
            );
        }
      }
    );
  }
}
