import 'dart:async';

import 'package:ipl_betting_app/library/api_base_helper.dart';
import 'package:ipl_betting_app/library/database_helper_abstract.dart';
import 'package:ipl_betting_app/repository/models/db_team.dart';
import 'package:ipl_betting_app/utils/api_paths.dart';

abstract class ITeamRepository {
  Future addTeam(String name);
  Future<List<DbTeam>> getTeams();
}

class ApiTeamRepository implements ITeamRepository {
  ApiBaseHelper _apiHelper;
  ApiTeamRepository(this._apiHelper);

  @override
  Future addTeam(String name) async {
    await _apiHelper.postApiData(ApiPaths.getTeams, name);
  }

  @override
  Future<List<DbTeam>> getTeams() async {
    List<dynamic> dbMatches =
        await _apiHelper.getApiDataAsMapList(ApiPaths.getTeams);
    return dbMatches.toList().map((d) => DbTeam.fromJson(d)).toList();
  }
}

class DbTeamRepository implements ITeamRepository {
  DatabaseHelperAbstract _db;
  DbTeamRepository(this._db);

  @override
  Future addTeam(String name) async {
    await _db.insertToDb(
        DbTeam.dbModel.tableName, DbTeam.fromName(name).toDbMap());
  }

  @override
  Future<List<DbTeam>> getTeams() async {
    List<Map<String, dynamic>> dbMatches =
        await _db.getResultForQuery(DbTeam.dbModel.selectQuery);
    return dbMatches.toList().map((d) => DbTeam.mapFromDb(d)).toList();
  }
}

class MockTeamRepository extends DbTeamRepository {
  MockTeamRepository(DatabaseHelperAbstract db) : super(db);
}
