import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class QuizExporter {
  static final tableName = "quiz";
  static final databaseVersion = 3;
  //haha dart be gud

  QuizExporter._privateConstructor();
  static final QuizExporter instance = QuizExporter._privateConstructor();

  Database db = null;

  String generateDBname()  {
    var now = new DateTime.now();
    return now.toString() + ".db";
  }

  getDatabase() async {
    if(db == null) {
        var directory = await getApplicationDocumentsDirectory();
        var path = join(directory.path + "/kviz_answers/", generateDBname());
        var database = await openDatabase(path,
        version: databaseVersion, onCreate: onCreateDatabase);
        db = database;
    }
    return db;
  }

  
  void setDatabaseToNull() {
    db = null;
  }

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    Database db = await getDatabase();
    return await db.query(tableName);
  }

  onCreateDatabase(Database database, int version) async {
    await database.execute("CREATE TABLE quiz(Odgovor TEXT, Question TEXT, TreeID INT)");    
  }

  Future<void> addQuizAnswer(Database db, int id, String text, String que) async {
    Database databae = await getDatabase();
    return await databae.execute("INSERT INTO quiz VALUES(?, ?, ?)", [text, que, id]);
  }
}
