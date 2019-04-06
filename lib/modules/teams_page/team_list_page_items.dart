import 'package:flutter/material.dart';
import 'package:ipl_betting_app/modules/generic_pages/basic_page_items.dart';
import 'package:ipl_betting_app/modules/models/vm_named_item.dart';
import 'package:ipl_betting_app/utils/theme_colors.dart';

class TeamListPageItems extends BasicPageItems {
  static final TeamListPageItems _singleton = new TeamListPageItems._internal();
  TeamListPageItems._internal();
  factory TeamListPageItems() {
    return _singleton;
  }

  Widget getListItem(VMNamedItem b, {Function(int beatId) onItemSelect}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: ThemeColors.primary,
        ),
        color: ThemeColors.surfaceDark,
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        onTap: () => onItemSelect(b.id),
        title: Container(
          margin: EdgeInsets.only(bottom: 7.0),
          child: Text(b.name),
        ),
      ),
    );
  }
}
