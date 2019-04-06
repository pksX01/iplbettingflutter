import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipl_betting_app/utils/basic_widgets.dart';
import 'package:ipl_betting_app/utils/theme_colors.dart';

abstract class GenericThemedItems {
  Widget getAlertDialog(String message, Function exit,
      [String title = "Message"]);

  StatefulWidget getWorkPageScaffold(Widget body, {String title = "LiteDMS"});
}

class MenuIcons {
  Widget getOkIcon(onPressed, {String title}) {
    return IconButton(icon: Icon(Icons.check), onPressed: onPressed);
  }

  Widget getExitIcon(onPressed, {String title}) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: title ?? "Exit",
        onPressed: onPressed);
  }

  Widget getReloadIcon(onPressed) {
    return IconButton(icon: Icon(Icons.refresh), onPressed: onPressed);
  }

  Widget getSearchIcon(onPressed) {
    return IconButton(icon: Icon(Icons.search), onPressed: onPressed);
  }

  Widget getOverflowMenu(List<String> menuItems, onMenuItemSelected) {
    return PopupMenuButton(
        onSelected: onMenuItemSelected,
        itemBuilder: (BuildContext context) {
          return menuItems
              .map((i) => PopupMenuItem(child: Text(i), value: i))
              .toList();
        });
  }
}

class BasicPageItems implements GenericThemedItems {
  MenuIcons menuIcons = MenuIcons();
  Widget getLoaderPage() {
    return Center(child: CircularProgressIndicator());
  }

  showErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message,
      {String actionLabel, bool textAsButton = true, action}) {
    assert(message != null);
    assert((actionLabel != null && action != null) || actionLabel == null);
    var messageArea = Text(message);
    var snackBar = SnackBar(
        content: (textAsButton && action != null)
            ? FlatButton(child: messageArea, onPressed: action)
            : messageArea,
        backgroundColor: ThemeColors.errorColor,
        action: (actionLabel == null || textAsButton)
            ? null
            : SnackBarAction(
                label: actionLabel ?? "Show",
                textColor: ThemeColors.textDarkHighEm,
                onPressed: action,
              ),
        duration: Duration(seconds: 3));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<Widget> showOkCancelPopup(context, Widget body,
      {List<Widget> actions, String title = "Are You Sure"}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(12.0),
          titlePadding: EdgeInsets.all(12.0),
          actions: actions,
          title: Text(title),
          content: body,
        );
      },
    );
  }

  Widget getCenteredButton(String name, Function onClick) {
    return Center(
        child: RaisedButton(
      onPressed: onClick,
      child: Text(name),
    ));
  }

  Widget backButtonConfirmationExit(Widget body,
      GlobalKey<ScaffoldState> scaffoldKey, Function() confirmedAction) {
    return WillPopScope(
        onWillPop: () async {
          showErrorSnackBar(scaffoldKey, "Press Here To Exit",
              actionLabel: "Exit", action: confirmedAction);
          return false;
        },
        child: body);
  }

  Widget getBoxedInputBox(Function(String value) onInputBoxDataChanged,
      {String value}) {
    var _controller = TextEditingController(text: value);
    return Container(
        width: 60.0,
        child: new TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.symmetric(vertical: 7.0),
            border: OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
          ),
          controller: _controller,
          onChanged: onInputBoxDataChanged,
          maxLength: 4,
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: false),
        ));
  }

  Widget getAlertDialog(String message, Function exit,
      [String title = "Message"]) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: exit,
        ),
      ],
    );
  }

  StatefulWidget getWorkPageScaffold(Widget body,
      {String title = "LiteDMS",
      List<Widget> menuItems,
      Widget bottomBar,
      Widget sideBar,
      Widget actionButton,
      Future<bool> Function() backButtonAction,
      GlobalKey<ScaffoldState> key}) {
    var scaffold = Scaffold(
      key: key,
      appBar: BasicAppBar(title, menuItems: menuItems),
      body: body,
      bottomNavigationBar: bottomBar,
      drawer: sideBar,
      floatingActionButton: actionButton,
    );
    return backButtonAction != null
        ? WillPopScope(
            onWillPop: backButtonAction,
            child: scaffold,
          )
        : scaffold;
  }
}
