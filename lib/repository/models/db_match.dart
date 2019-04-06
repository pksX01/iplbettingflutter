
import 'package:ipl_betting_app/repository/models/db_model.dart';
import 'package:ipl_betting_app/repository/models/db_team.dart';

class DbMatch {

  static const String dateColumn="date";
  static const String tableName="matches";

  int id;
  String name;
  DateTime date;
  int team1;
  int team2;
  String team1Name;
  String team2Name;

//DB Query
  static DbModel dbModel = DbModel(tableName, <String>[
    """
    Create Table $tableName (id Integer Primary Key, name nvarchar(256),$dateColumn DateTime,team1 int, team2 int )
    """
  ],selectQuery: """
  select m.id,m.name,$dateColumn,t1.name team1Name ,t2.name team2Name, m.team1,m.team2 from $tableName m
  join ${DbTeam.tableName} t1 on t1.id=m.team1
  join ${DbTeam.tableName} t2 on t2.id=m.team2
  """);


  DbMatch.fromJson(dynamic obj)
      : this.id = obj['Id'],
        this.name = obj['Name'],
        this.date=obj['Date'],
        this.team1=obj['Team1'],
        this.team2=obj['Team2']
        ;

  DbMatch.mapFromDb(dynamic obj)
      : this.id = obj['id'],
        this.name = obj['name'],
        this.date=DateTime.parse(obj['date']),
        this.team1Name=obj['team1Name'],
        this.team2Name=obj['team2Name'];

  Map<String, dynamic> toDbMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = this.name;
    map['date']=this.date.toIso8601String();
    map['team1']=this.team1;
    map['team2']=this.team2;
    return map;
  }

  DbMatch._fake(int index)
      : id = index,
        name = "Demo Match $index";

  static List<DbMatch> getFakeBeats() {
    return List<DbMatch>.generate(10, (i) => DbMatch._fake(i));
  }

  static List<DbMatch> generate() {
    return List<DbMatch>.generate(
      3,
      (i) => DbMatch._fake(i),
    );
  }
}
