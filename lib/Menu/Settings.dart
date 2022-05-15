import 'dart:ui';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Utilities/Globals.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();

}

class Language {
  int id;
  String name;

  Language(this.id, this.name);

  static List<Language> getLanguages(){
    return <Language> [
      Language(1, "Slovenščina"),
      Language(2, "English"),
    ];

  }
}


class _SettingsState extends State<Settings> {
  List<bool> variables = [false,false,false];
  List<Language> languages = Language.getLanguages();
  List<DropdownMenuItem<Language>> dropDownMenuItems;
  Language selectedLangauge;

  TextStyle m_pTextStyle;

  @override
  void initState() {
      dropDownMenuItems = buildMenuItems(languages);
      selectedLangauge = dropDownMenuItems[0].value;
      m_pTextStyle = TextStyle(color: m_pTextColor, fontSize: m_iTextSize);
      super.initState();
  }

  List<DropdownMenuItem<Language>> buildMenuItems(List langs){
     List<DropdownMenuItem<Language>> items = [];
     for(Language lang in langs) {
        items.add(DropdownMenuItem(
          value: lang,
          child: Text(lang.name),

        ));
     }
    return items;
  }

  onChangeDropdownItem(Language selLangs) {
      setState(() {
        selectedLangauge = selLangs;
      });

  }
  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: m_pBackGroundColor,
      onColorChanged: (Color color) =>
          setState(() => m_pBackGroundColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
    Future<bool> colorPickerDialogText() async {
    return ColorPicker(
      color: m_pTextColor,
      onColorChanged: (Color color) =>
          setState(() => m_pTextColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Izberi barvo',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Izberi odtenek barve',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Izberi barvo in njene odtenke',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
    Future<bool> _onWillPop() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('m_iTextSize', m_iTextSize);
      prefs.setDouble('m_iTitleSize', m_iTitleSize);

      Navigator.of(context).pop(true);
    }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Nastavitve"),
            backgroundColor: Colors.blue,
          ),
          body: Container(

            padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: m_pBackGroundColor,
                borderRadius: BorderRadius.circular(10)),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
            
              children: <Widget>[ 
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Jezik: ", style:m_pTextStyle,),
                  DropdownButton<Language>(
                        value: selectedLangauge,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: SizedBox(),
                        items: dropDownMenuItems, 
                        onChanged: onChangeDropdownItem, 
                  ),
                  ]
                ), 
                Text("Velikost črk:", style: m_pTextStyle,),
                Slider(
                  value: m_iTextSize, 
                  min: 10,
                  max: 50,
                  label: m_iTextSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      m_iTextSize = value;
                      m_pTextStyle = TextStyle(color: m_pTextColor, fontSize: m_iTextSize);
                    });
                  },),
                  Text("Velikost črk na naslovu:", style: m_pTextStyle),
                  Slider(
                  value: m_iTitleSize, 
                  min: 10,
                  max: 50,
                  label: m_iTitleSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      m_iTitleSize = value;
                    });
                  },),
                Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Text("Barva bralnih površin: ", style: m_pTextStyle,),
                      ColorIndicator(
                          width: 22,
                          height: 22,
                          borderRadius: 22,
                          hasBorder: true,
                          borderColor: Colors.black,
                          color: m_pBackGroundColor,
                          onSelect: () async {
                            final Color colorBeforeDialog = m_pBackGroundColor;
                            if (!(await colorPickerDialog())) {
                              setState(() {
                                m_pBackGroundColor = colorBeforeDialog;
                              });
                            }
                        },
                      ),
                    ],
                ),
                Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Text("Barva črk na bralnih površin: ", style: m_pTextStyle,),
                      ColorIndicator(
                          width: 22,
                          height: 22,
                          borderRadius: 22,
                          hasBorder: true,
                          borderColor: Colors.black,
                          color: m_pTextColor,
                          onSelect: () async {
                            final Color colorBeforeDialog1 = m_pTextColor;
                            if (!(await colorPickerDialogText())) {
                              setState(() {
                                m_pTextColor = colorBeforeDialog1;
                              });
                            }
                            setState(() {
                                m_pTextStyle = TextStyle(color: m_pTextColor, fontSize: m_iTextSize);
                            });
                        },
                      ),
                    ],
                ),
              ],
            ),
            ),
            backgroundColor: m_pBackGroundColor,
          ),
    );
  }
}

