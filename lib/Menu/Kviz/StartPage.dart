import 'package:flutter/material.dart';
import 'KvizBuilder.dart';
import 'SchoolKvizBuilder.dart';
import 'Answers.dart';

class KvizStartPage extends StatefulWidget {
  KvizStartPage({Key key}) : super(key: key);

  @override
  _KvizStartPageState createState() => _KvizStartPageState();
}

class _KvizStartPageState extends State<KvizStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kviz'),
      ),
      body: Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            child: buildRoundedCard(
                "Poučni kviz",
                0.14,
                Icons.school,
                Colors.red[300],
                Colors.red,
                Colors.orange,
                Colors.white,
                Colors.white10,
                context,
                SchoolKviz()),
          ),
          Container(
            child: buildRoundedCard(
                "Zabavni kviz",
                0.14,
                Icons.nature,
                Colors.blue[300],
                Colors.blue,
                Colors.orange,
                Colors.white,
                Colors.white10,
                context,
                CategoryPage()),
          ),
        ]),
        alignment: Alignment.center,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check_box),
        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Answers())),
      ),
    );
  }
}

Widget buildRoundedCard(String name, double proc, IconData icon, Color gr1,
        Color gr2, Color slc, Color tcol, Color scol, BuildContext context, Widget fun) =>
    Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gr1, gr2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => fun)), // button pressed
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 60,
                color: tcol,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: tcol,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: SizedBox.fromSize(
                  size: Size(86, 56), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 36,
                            ), // icon // text
                            Text(
                              "Začni",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ]
        ),
        ),
      ),
    );
