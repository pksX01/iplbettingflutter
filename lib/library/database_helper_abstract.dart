import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class DatabaseHelperAbstract {
  Future<Database> get db;

  Future<int> updateData(
      String tableName, String updateStatement, String filterStatement) async {
    var query = "update $tableName set $updateStatement where $filterStatement";
    var dbclient = await db;
    return await dbclient.rawUpdate(query);
  }

  Future executeCommand(String sql) async {
    var dbClient = await db;
    return await dbClient.execute(sql);
  }

  Future<dynamic> getResultForQuery(String sql) async {
    var dbClient = await db;
    return await dbClient.rawQuery(sql);
  }

  @protected
  Future<Database> initDb(String dbPath, int version) async {
    var mainDb = await openDatabase(dbPath,
        version: version, onUpgrade: onUpgrade, onDowngrade: onDowngrade);
    return mainDb;
  }

  Future<int> insertToDb(String tableName, Map<String, dynamic> data) async {
    var dbclient = await db;
    int insertId = 0;
    await dbclient.insert(tableName, data);
    return insertId;
  }

  @protected
  Future onUpgrade(Database db, int oldVersion, int newVersion);

  @protected
  Future onDowngrade(Database db, int oldVersion, int newVersion);

  Future<int> insertSingleToDb(
      String tableName, Map<String, dynamic> json) async {
    var dbclient = await db;
    int insertId = await dbclient.insert(tableName, json);
    return insertId;
  }
}
