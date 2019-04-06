import 'package:flutter/material.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_base_class.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_response.dart';
import 'package:ipl_betting_app/modules/generic_pages/basic_page.dart';
import 'package:ipl_betting_app/modules/generic_pages/bloc_listener_base_page.dart';
import 'package:ipl_betting_app/modules/models/vm_named_item.dart';
import 'package:ipl_betting_app/modules/teams_page/team_list_bloc.dart';
import 'package:ipl_betting_app/modules/teams_page/team_list_page_items.dart';
import 'package:ipl_betting_app/utils/const_strings.dart';

class TeamListPage extends BasicPage {
  final title = "Data Loading";
  @override
  TeamListPageItems get pageItems => new TeamListPageItems();
  @override
  State<TeamListPage> createState() => _TeamPageState();
}

class _TeamPageState extends BlocListenerBasePage<TeamListPage> {
  final _bloc = TeamListBloc();
  Widget getRetryButtonPage() {
    return widget.pageItems.getWorkPageScaffold(
        widget.pageItems
            .getCenteredButton(ConstStrings.Retry, () => _bloc.loadTeams()),
        title: ConstStrings.Retry);
  }

  @override
  Widget build(BuildContext context) {
    _bloc.loadTeams();
    return getPageBuilder();
  }

  Widget getDefaultPage(Iterable<VMNamedItem> teams) {
    var teamList = teams.toList();
    return widget.pageItems.getWorkPageScaffold(
        ListView.builder(
            itemCount: teamList.length,
            itemBuilder: (BuildContext context, int index) {
              var item = teamList[index];
              return widget.pageItems.getListItem(item, onItemSelect: (int) {});
            }),
        actionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: showAddTeamPopUp,
        ));
  }

  showAddTeamPopUp() {}
  StreamBuilder<BlocResponse> getPageBuilder() {
    return StreamBuilder<BlocResponse>(
        stream: _bloc.dataController,
        builder: (context, AsyncSnapshot<BlocResponse> snapshot) {
          if (snapshot.hasError) {
            return getRetryButtonPage();
          } else if (snapshot.hasData) {
            return getLoaderStatusAndresult(
                snapshot.data, getDefaultPage, getRetryButtonPage);
          }
          return widget.pageItems.getLoaderPage();
        });
  }

  @override
  BlocBaseClass get messengerBlock => _bloc;

  @override
  onTaskCompleted(BlocResponse taskCompletionFlag) async {}

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}