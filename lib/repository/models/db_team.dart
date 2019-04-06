import 'package:ipl_betting_app/repository/models/db_model.dart';

class DbTeam {
  static const String tableName="teams";
  DbTeam.fromName(this.name);
  
  int id;
  String name;

//DB Query
  static DbModel dbModel = DbModel(tableName, <String>[
    """
    Create Table $tableName (id Integer Primary Key, name nvarchar(256))
    """
  ]);

  DbTeam.fromJson(dynamic obj)
      : this.id = obj['Id'],
        this.name = obj['Name'];

  DbTeam.mapFromDb(dynamic obj)
      : this.id = obj['id'],
        this.name = obj['name'];

  Map<String, dynamic> toDbMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = this.name;
    return map;
  }

  DbTeam._fake(int index)
      : id = index,
        name = "Demo Beat $index";

  static List<DbTeam> getFakeBeats() {
    return List<DbTeam>.generate(10, (i) => DbTeam._fake(i));
  }

  static List<DbTeam> generate() {
    return List<DbTeam>.generate(
      3,
      (i) => DbTeam._fake(i),
    );
  }
}
