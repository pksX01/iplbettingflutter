class DbModel extends DbReadModel {
  static const dbIdColName = "id";

  String _tableName;
  List<String> _migrationQueries;

  String get tableName => _tableName;
  List<String> get migrationQueries => _migrationQueries;
  List<String> get revertQueries =>
      <String>["Drop Table if exists $_tableName;"];
  String get deleteQuery => "delete from $_tableName";

  DbModel(this._tableName, this._migrationQueries, {String selectQuery})
      : super(selectQuery ?? "select * from $_tableName");
}

class DbReadModel {
  String _selectQuery;
  String get selectQuery => _selectQuery;

  DbReadModel(this._selectQuery) {
    selectQuery;
  }
}
