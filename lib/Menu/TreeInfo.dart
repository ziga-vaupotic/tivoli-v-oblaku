
import 'package:audioplayers/audio_cache.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_tivoli/Menu/PictureViewer.dart';
import 'package:flutter/material.dart';
import 'package:project_tivoli/Utilities/Globals.dart';
import '../Databases/RetriveDataFromSQL.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class TreeInfo extends StatefulWidget {
  final int treeIndex;
  final LatLng m_pLocalPostion;
  
  const TreeInfo(this.treeIndex,this.m_pLocalPostion);

  @override
  _TreeInfoState createState() => _TreeInfoState();
  
}

TextStyle tabStyle = new TextStyle(color: Colors.grey);
TextStyle m_pHeading = TextStyle(fontSize: m_iTitleSize, color: m_pTextColor);
TextStyle m_pText = TextStyle(fontSize: m_iTextSize, color: m_pTextColor);


class _TreeInfoState extends State<TreeInfo> with SingleTickerProviderStateMixin  {
  int fileCount = 0;
  int audioFileCount = 0;
    TabController _tabController;

  AudioCache cache;
  AudioPlayer audioPlayer;
  int m_iTabindex = 0;

  final getInfoFromDb = GetInfoFromDB.instance;
  
  Future<List> getFileCount(BuildContext context) async 
  {
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
      .where((String key) => key.contains("assets/tree_images/" + getInfoFromDb.kor[widget.treeIndex].idDrevesa)).toList().where((String key) => key.contains(".jpg"));

    fileCount = imagePaths.length;

    final imagePathsAudio = manifestMap.keys
      .where((String key) => key.contains("assets/tree_images/" + getInfoFromDb.kor[widget.treeIndex].idDrevesa)).toList().where((String key) => key.contains(".mp3"));

    audioFileCount = imagePathsAudio.length;

  }



  Widget buildImageCarousel() {
    return CarouselSlider.builder(
      itemCount: fileCount, 
      itemBuilder: (BuildContext context, int index) {
        return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PictureViewer(index, "assets/tree_images/" + getInfoFromDb.kor[widget.treeIndex].idDrevesa + "/" + index.toString() + ".jpg", getInfoFromDb.kor[widget.treeIndex].name)),
                    ),
                child: Image(image:AssetImage("assets/tree_images/" + getInfoFromDb.kor[widget.treeIndex].idDrevesa + "/" + index.toString() + ".jpg"), fit: BoxFit.fitHeight)),
            );
          },
        );
      }, 
      options: CarouselOptions(height: 400.0, 
          autoPlay: false, 
          viewportFraction: 0.5,
          enlargeCenterPage: true,
          autoPlayInterval: Duration(seconds: 5),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    m_iTabindex = 0;
    cache = new AudioCache();
    audioPlayer = new AudioPlayer();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  }

  Future<bool> _onWillPop() async
  {
      await audioPlayer.stop();
      Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder(
        future: getFileCount(context),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Container();
          }
          else 
          {
            m_pHeading = TextStyle(fontSize: m_iTitleSize, color: m_pTextColor);
            m_pText = TextStyle(fontSize: m_iTextSize, color: m_pTextColor);
            return Scaffold(
                appBar: PreferredSize (
                  preferredSize: Size.fromHeight(250.0), 
                  child: AppBar(
                  flexibleSpace: buildImageCarousel(),
                  backgroundColor: Colors.white60,
                  
                ),
                ),
                body:_tabSection(context, widget.treeIndex, widget.m_pLocalPostion,audioFileCount),
                persistentFooterButtons: [
                  if(audioFileCount > 0)   
                    ButtonTheme(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0), //adds padding inside the button
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
                      minWidth: 0, //wraps child's width
                      height: 0, //wraps child's height
                      child: FlatButton(             
                      onPressed: () => _playAudio(widget.treeIndex, 1), 
                      child: Icon(Icons.headset),                         
                    ),
                  ),
                  ],

                );
            }
        }
      ),
    );
  }
  void _playAudio(int m_iTreeIndex, int m_iPart) async
  {
      if(audioPlayer.state == AudioPlayerState.PLAYING)
      {
        audioPlayer.stop();
        cache.fixedPlayer.stop();
        return;
      }

      String alarmAudioPath;
      switch(m_iTabindex)
      {
        case 0: {
            alarmAudioPath = "tree_images/" + getInfoFromDb.kor[m_iTreeIndex].idDrevesa + "/Splosno.mp3";
        }break;
        case 1: {
            alarmAudioPath = "tree_images/" + getInfoFromDb.kor[m_iTreeIndex].idDrevesa + "/Opis.mp3";
        }break;
        case 2: {
            alarmAudioPath = "tree_images/" + getInfoFromDb.kor[m_iTreeIndex].idDrevesa + "/Opis.mp3";
        }break;

      }
      
      audioPlayer = await cache.play(alarmAudioPath);
  }
  Widget _tabSection(BuildContext context, int treeIndex, LatLng m_pLocalPos, int audioFile) {
    return  Center(
        child: Column(
          children: <Widget>[
            TabBar(
              labelColor: Colors.grey,
              controller: _tabController,
              tabs: <Widget>[
              Tab(text: "Splošno"),
              Tab(text: "O drevesu"),
              Tab(text: "Zanimivost"),
              ],
              onTap: (index) {
                m_iTabindex = index;
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SingleChildScrollView(
                  child: Container(
                    color: m_pBackGroundColor,
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start ,
                      children: <Widget>[
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ 
                            Text("Ime: ", style: m_pText,),
                            Text(getInfoFromDb.kor[treeIndex].name, style: m_pText,)
                          ]
                        ),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ 
                            Text("Angleško ime: ", style: m_pText,),
                            Text(getInfoFromDb.kor[treeIndex].angleskoIme, style: m_pText,)
                          ]
                        ),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ 
                            Text("Latinsko ime: ", style: m_pText,),
                            Text( getInfoFromDb.kor[treeIndex].latinskoIme, style: m_pText,)
                          ]
                        ),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ 
                            Text("Družina: ", style: m_pText,),
                            Text(getInfoFromDb.kor[treeIndex].druzina, style: m_pText,)
                          ]
                        ),
                        SizedBox(height: 20),
                        Text(getInfoFromDb.kor[treeIndex].splosno, style: m_pText,),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(  
                  child: Container(
                    color: m_pBackGroundColor,
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: <Widget>[
                          Text("Opis: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].opisDrevesa, style: m_pText,),
                          Text("Cvetenje: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].cvet, style: m_pText,),
                          Text("Razmnoževanje: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].razm, style: m_pText,),
                          Text("Rastišče: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].rast, style: m_pText,),
                          Text("Splošna razširjenost: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].raz, style: m_pText,),
                          Text("Razširjenost v Sloveniji: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].razSLO, style: m_pText,),
                          Text("Uporabnost: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].uporabnost, style: m_pText,),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(  
                  child: Container(
                    color: m_pBackGroundColor,
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: <Widget>[
                          Text("Zanimivosti: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].zanimivost, style: m_pText,),
                          Text("Izjemni primerki: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].izjemniPrimerki, style: m_pText,),
                          Text("Opozorilo: ", style: m_pHeading),
                          Text(getInfoFromDb.kor[treeIndex].opozorilo, style: m_pText,),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            )
          ],
        ),
    );
  }
}