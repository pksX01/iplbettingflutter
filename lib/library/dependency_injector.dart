import 'dart:async';
import 'package:ipl_betting_app/library/database_helper_abstract.dart';
import 'package:ipl_betting_app/repository/database_helper.dart';
import 'package:ipl_betting_app/repository/match_repository.dart';
import 'package:ipl_betting_app/repository/team_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipl_betting_app/library/api_base_helper.dart';


enum Flavor { Mock, Prod, Debug }

class ThemeInjector {
  static final ThemeInjector _singleton = new ThemeInjector._internal();

  factory ThemeInjector() {
    return _singleton;
  }

  ThemeInjector._internal();
}



//DI
class Injector {
  static const TokenKey = "AuthToken";
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  SharedPreferences _prefs;

  factory Injector() {
    return _singleton;
  }

  Injector._internal();
  String get token => _prefs.getString(TokenKey);
  

  String get _appbaseURL {
    switch (_flavor) {
      case Flavor.Prod:
        return "http://ipl.restroid.in";
      case Flavor.Debug:
        return "http://ipl.restroid.in";
      default:
        return "http://ipl.restroid.in";
    }
  }

  DatabaseHelperAbstract get _dbHelper => DatabaseHelper();
  ApiBaseHelper get _apiHelper => ApiBaseHelper(_appbaseURL,"");

  ITeamRepository get teamRepository => new ApiTeamRepository(_apiHelper);
  IMatchRepository get matchRepository => new DbMatchRepository(_dbHelper);

  
  void updateToken(String token) {
    _prefs.setString(TokenKey, token);
  }

    Future cleanUp() async {
    updateToken(null);
  }
}
