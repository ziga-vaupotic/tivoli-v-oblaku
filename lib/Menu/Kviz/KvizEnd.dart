import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../main.dart';
class KvizEndPage extends StatefulWidget {
  final int m_iScore;

  const KvizEndPage(this.m_iScore);

  @override
  _KvizEndPageState createState() => _KvizEndPageState();

}


class _KvizEndPageState extends State<KvizEndPage> {

  void makeRoutePage({BuildContext context, Widget pageRef}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
        (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Icon(MdiIcons.trophyAward, size: 200, color: Colors.yellowAccent,),
            Text("Zbral si: " + widget.m_iScore.toString() + " točk"),
            FlatButton(onPressed: () => makeRoutePage(context: context, pageRef: MyHomePage()), child: Text("Klikni me"), color: Colors.blue,)
          ]
          ),
        ),

      );
  }
}
