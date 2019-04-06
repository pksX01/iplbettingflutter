import 'dart:async';

import 'package:ipl_betting_app/library/database_helper_abstract.dart';
import 'package:ipl_betting_app/repository/models/db_match.dart';
abstract class IMatchRepository{
  Future addMatch(DbMatch match );
  Future<List<DbMatch>> getLastMatch(DateTime now, int count );
}
class DbMatchRepository implements IMatchRepository {
  DatabaseHelperAbstract _db;
  DbMatchRepository(this._db);
  
  @override
  Future addMatch(DbMatch match ) async {
    await _db.insertToDb(DbMatch.dbModel.tableName,match.toDbMap());
  }

 @override
  Future<List<DbMatch>> getLastMatch(DateTime now, int count ) async {
   var query=DbMatch.dbModel.selectQuery + " where ${DbMatch.dateColumn}< '$now' order by ${DbMatch.dateColumn}";
   List<Map<String, dynamic>> dbMatches =
        await _db.getResultForQuery(query);
    return dbMatches.toList().map((d) => DbMatch.mapFromDb(d)).toList().take(count);
  }

}

class MockMatchRepository extends DbMatchRepository {
  MockMatchRepository(DatabaseHelperAbstract db) : super(db);
}
