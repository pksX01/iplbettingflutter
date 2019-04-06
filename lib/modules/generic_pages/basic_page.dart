import 'dart:core';
import 'package:flutter/material.dart';
import 'package:ipl_betting_app/modules/generic_pages/basic_page_items.dart';

abstract class BasicPage extends StatefulWidget {
  final BasicPageItems pageItems = new BasicPageItems();
}
