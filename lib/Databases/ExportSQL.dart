import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseExporter {
  static final databaseName = "UserInfo.db";
  static final tableName = "User";
  static final columKvizPoints = "KvizPoints";
  static final columnTreesDiscoverd = "TreesDiscoverd";
  static final databaseVersion = 3;

  DatabaseExporter._privateConstructor();
  static final DatabaseExporter instance =
      DatabaseExporter._privateConstructor();

  getDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, databaseName);
    var database = await openDatabase(path,
        version: databaseVersion, onCreate: onCreateDatabase);
    return database;
  }

  onCreateDatabase(Database database, int version) async {
    await database
        .execute("CREATE TABLE User(KvizPoints INT, TreesDiscoverd TEXT)");
    await database.execute("INSERT INTO User VALUES(0, ' ')");
  }

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    Database db = await getDatabase();
    return await db.query(tableName);
  }

  Future<void> updateKvizPoints(int points) async {
    Database db = await getDatabase();
    final row = await querryAllRows();

    if (row[0]["KvizPoints"] > points) return;
    return await db.execute("UPDATE User SET KvizPoints = ? WHERE 1", [points]);
  }

  Future<int> getWordCounts() async {
    final row = await querryAllRows();
    String data = row[0]["TreesDiscoverd"];
    int wordcount = 0;
    for (var i = 0; i < data.length; i++) {
      if (i == 0) continue;

      if (data[i] != " " && data[i - 1] == " ") wordcount++;
    }
    return wordcount;
  }

  Future<void> updateTrees(String treeID) async {
    Database db = await getDatabase();
    final row = await querryAllRows();
    if (row[0]["TreesDiscoverd"].toString().contains(" " + treeID)) return;
    return await db.execute("UPDATE User SET TreesDiscoverd = ? WHERE 1",
        [row[0]["TreesDiscoverd"] + " " + treeID]);
  }
}
