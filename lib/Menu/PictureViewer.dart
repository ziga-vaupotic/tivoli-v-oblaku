import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_exif/flutter_exif.dart';

class PictureViewer extends StatefulWidget {
  final int m_iIndex;
  final String m_strTreePath;
  final String m_strImeDrevesa;

  
  const PictureViewer(this.m_iIndex, this.m_strTreePath, this.m_strImeDrevesa);

  

  @override
  _PictureViewerState createState() => _PictureViewerState();
}

class _PictureViewerState extends State<PictureViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[ 
          PhotoView(
            imageProvider: AssetImage(widget.m_strTreePath),
            maxScale: 0.9,
            minScale: 0.1,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child:Column(
              children: <Widget>[ 
                Text("Slika " + (widget.m_iIndex + 1).toString(), style: TextStyle( color: Colors.white),),
                Text("Ime drevesa: " + widget.m_strImeDrevesa, style: TextStyle( color: Colors.white),),
                Text("Fotograf: Matija Matanič", style: TextStyle( color: Colors.white),),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}