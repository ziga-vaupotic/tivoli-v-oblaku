import 'package:flutter/material.dart';
import "GetAnswersFromDB.dart";
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Answers extends StatefulWidget {
  Answers({Key key}) : super(key: key);

  @override
  _AnswersState createState() => _AnswersState();
}



class _AnswersState extends State<Answers> {

  List<String> m_lContents = [];   
  String m_strPath;

  Future<List> getDatabaseList() async 
  {
    m_lContents.clear();
    int m_iRet;
    var m_pDirectory = await getApplicationDocumentsDirectory();
    var m_pDir = new Directory(m_pDirectory.path + "/kviz_answers/");
    m_strPath = m_pDir.path;
    for(var m_strFiles in m_pDir.listSync()) 
    {
      m_lContents.add(m_strFiles.toString());
    }  
    return m_lContents;
  }

  String getDate(String m_strDBName) {
    String m_strRet = "";

    for(int i = 0; i < 10; i++){
      m_strRet += m_strDBName.split("/kviz_answers/").last[i];

    }

    return m_strRet;
  }
  String getTime(String m_strDBName) {
    String m_strRet = "";

    for(int i = 10; i < 19; i++){
      m_strRet += m_strDBName.split("/kviz_answers/").last[i];

    }

    return m_strRet;
  }

  @override
  void initState() {
      m_lContents.clear();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatabaseList(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Container();
          }
          else 
          {
            return Scaffold(
              appBar: AppBar(
                title: Text('Odgovori'),
              ),
              body: SingleChildScrollView( 
                child: Container(
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>
                    [
                      for(var i = m_lContents.length - 1; i > 0; i--)
                        OutlineButton(
                          child: Text("Datum: " + getDate(m_lContents[i]) + " " + getTime(m_lContents[i])
                          , style: TextStyle(fontSize: 18)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnswersFromDB(m_lContents[i]))),

                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        )
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}

