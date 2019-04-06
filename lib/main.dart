import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipl_betting_app/modules/teams_page/beat_list_page.dart';
import 'package:ipl_betting_app/utils/navigation_pages.dart';

Future main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    "/": (BuildContext context) => TeamListPage(),
    NavigationPages.teamListPage: (BuildContext context) => TeamListPage(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Ipl Match',
      routes: routes,
    );
  }
}
