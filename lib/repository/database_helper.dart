import 'package:flutter/material.dart';
import 'package:ipl_betting_app/library/database_helper_abstract.dart';
import 'package:ipl_betting_app/repository/models/db_match.dart';
import 'package:ipl_betting_app/repository/models/db_team.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io" as io;
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper extends DatabaseHelperAbstract {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static Database _db;
  static const DATABASE_VERSION = 1;

  Future cleanDb() async {
    await onUpgrade(await db, 0, DATABASE_VERSION);
  }

  @override
  @protected
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String dbPath = join(documentDirectory.path, "main.db");
      _db = await super.initDb(dbPath, DATABASE_VERSION);
      return _db;
    }
  }

  @override
  @protected
  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading db from $oldVersion to $newVersion");
    var migrationQueries = <List<String>>[
      DbMatch.dbModel.migrationQueries,
      DbTeam.dbModel.migrationQueries,
    ];
    switch (oldVersion) {
      case 0: //For 0->1
        await onDowngrade(db, newVersion, 0);
        for (var query in migrationQueries) {
          if (query.length > 0) {
            await db.execute(query[0]);
          }
        }
        if (newVersion > 1) continue case_1;
        break;
      case_1:
      case 1: //For 1->2
        for (var query in migrationQueries) {
          if (query.length > 1) {
            await db.execute(query[1]);
          }
        }
        if (newVersion > 2) continue case_2;
        break;
      case_2:
      case 2:
        break;
    }
  }

  @override
  @protected
  Future onDowngrade(Database db, int oldVersion, int newVersion) async {
    print("Downgrading db from $oldVersion to $newVersion");
    var migrationQueries = <List<String>>[
      DbMatch.dbModel.revertQueries,
      DbTeam.dbModel.revertQueries,
    ];
    switch (oldVersion) {
      case 2: //For 2->1
        for (var query in migrationQueries) {
          if (query.length > 1) {
            await db.execute(query[1]);
          }
        }
        continue case_1;
      case_1:
      case 1: //For 1->0
        for (var query in migrationQueries) {
          if (query.length > 0) {
            await db.execute(query[0]);
          }
        }
        break;
    }
  }
}
