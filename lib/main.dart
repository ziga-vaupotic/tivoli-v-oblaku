import 'package:flutter/material.dart';
import 'package:project_tivoli/Databases/RetriveDataFromSQL.dart';
import 'package:project_tivoli/Menu/GMap.dart';
import 'Menu/ONas.dart';
import 'Menu/GMap.dart';
import 'Menu/Settings.dart';
import 'Menu/Kviz/StartPage.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilities/Globals.dart';

void main() {
  runApp(MyApp());
  final getInfoFromDb = GetInfoFromDB.instance;
  getInfoFromDb.getList();
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tivoli v oblaku',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tivoli v oblaku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final getInfoFromDb = GetInfoFromDB.instance;
  double getallTree() {
    double index = 0;
    getInfoFromDb.kor.forEach((element) {
      if (element.beenThere == 1) {
        index++;
      }
    });
    print(index);
    return index;
  }
  String appName ;
  String packageName;
  String version;
  String buildNumber;


  Future<void> getBuildInfo() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;    
      buildNumber = packageInfo.buildNumber;
    });
    
    final prefs = await SharedPreferences.getInstance();
    m_iTextSize = prefs.getDouble('m_iTextSize') ?? 16;
    m_iTitleSize = prefs.getDouble('m_iTitleSize') ?? 20;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBuildInfo() ,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Container();
        }
        else 
        {
          return Scaffold(
            body: Column( 
                children: [ 
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Container(
                        height: 225.0,
                        child: DrawerHeader(
                            child: Image(image: AssetImage("assets/menu_ass/logo.png"), height: 120, width: 120,),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Zemljevid z drevesi'),
                        onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GMap()),
                      ),
                      ),
                      ListTile(
                        leading: Icon(Icons.ballot),
                        title: Text('Kviz'),
                        onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KvizStartPage())),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Nastavitve'),
                        onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings())),
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('O nas'),
                        onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ONas())),
                      ),
                    ],
                  ),               
                ],
            ),
            persistentFooterButtons: [Text("Verzija: " + version.toString())],
          );
        }
      }
    );
  }
}