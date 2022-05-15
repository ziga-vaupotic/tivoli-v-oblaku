import "package:google_maps_flutter/google_maps_flutter.dart";
import '../Databases/ImportSQL.dart';
import "../Utilities/SQLParser.dart";

class GetInfoFromDB {
  GetInfoFromDB._privateConstructor();
  static final GetInfoFromDB instance = GetInfoFromDB._privateConstructor();

  final db = DatabaseHelper.instance;
  List<SQLParser> kor = [];
  SQLParser cur;

  _fetchRows() async {
    final allRows = await db.querryAllRows();
    
    allRows.forEach((row) => {
          cur = new SQLParser(),
          cur.index = int.parse(row['index'].toString()),
          cur.lat = double.parse(row['LATITUDE'].toString()),
          cur.long = double.parse(row['LONGITUDE'].toString()),
          cur.name = row['IME DREVESA'].toString(),
          cur.idDrevesa = row['ID DREVESA'].toString(),
          cur.opisDrevesa = row['OPIS'].toString(),
          cur.splosno = row['SPLOŠNO'].toString(),
          cur.angleskoIme = row['ANGLEŠKO IME'].toString(),
          cur.latinskoIme = row['LATINSKO IME'].toString(),
          cur.druzina = row['DRUŽINA'].toString(),
          cur.cvet = row['CVETENJE'].toString(),
          cur.razm = row['RAZMNOŽEVANJE'].toString(),
          cur.rast = row['RASTIŠČE'].toString(),
          cur.raz = row['SPLOŠNA RAZŠIRJENOST'].toString(),
          cur.razSLO = row['RAZŠIRJENOST V SLOVENIJI'].toString(),
          cur.uporabnost = row['UPORABNOST'].toString(),
          cur.izjemniPrimerki = row['IZJEMNI PRIMERKI'].toString(),
          cur.zanimivost = row['ZANIMIVOSTI'].toString(),
          cur.opozorilo = row['OPOZORILO'].toString(),
          kor.add(cur)
        });
    return kor;
  }
  Future<List<SQLParser>> getList() async {
    if (kor.isNotEmpty) return kor;
    kor = await _fetchRows();
    return kor;
  }

}
