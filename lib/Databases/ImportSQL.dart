import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final _databaseName = "asset_excel.db";
  static final tableName = "drevesa";
  static final columnID = "index";
  static final columnLat = "Lats";
  static final columnLong = "Longs";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    ByteData data = await rootBundle.load(join('assets', 'excel.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await new File(path).writeAsBytes(bytes);

    return await openDatabase(
      path,
      version: _databaseVersion,
    );
  }
  void updateInfo(int index){
      Database db = _database;
      db.rawUpdate("UPDATE drevesa SET bt=1 WHERE \"index\"=3", [3]);
  }

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> querry(String text) async {
    Database db = await instance.database;
    return await db.rawQuery(text);
  }
}
