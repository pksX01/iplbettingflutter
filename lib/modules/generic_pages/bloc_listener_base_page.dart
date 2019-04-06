import 'package:flutter/material.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_base_class.dart';
import 'package:ipl_betting_app/modules/bloc_models/bloc_response.dart';
import 'package:ipl_betting_app/modules/generic_pages/basic_page.dart';

abstract class BlocListenerBasePage<T extends BasicPage> extends State<T> {
  BlocBaseClass get messengerBlock;

  @override
  void initState() {
    super.initState();
    listenToErrors();
  }

  void listenToErrors() {
    messengerBlock.errorReceiver.listen((data) => _showMessage(
        data != null ? data.toString() : "Some Unknown Error Occurred!"));

    messengerBlock.messageReceiver.listen((data) => _showMessage(
        data.message != null
            ? data.message.toString()
            : "Some Unknown Error Occurred!",
        onExit: data.onExit));

    messengerBlock.taskCompletionFlagReciever.listen(onTaskCompleted);
  }

  onTaskCompleted(BlocResponse taskCompletionFlag);

  getLoaderStatusAndresult(
      BlocResponse blocResponse, completedAction, Function() errorAction,
      {String loaderTitle = "Data Loading"}) {
    switch (blocResponse.status) {
      case BlocResponseStatus.completed:
        return completedAction(blocResponse.data);
      case BlocResponseStatus.loading:
        return widget.pageItems.getLoaderPage();
      case BlocResponseStatus.error:
        return errorAction();
    }
  }

  _showMessage(msg, {Function onExit}) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return widget.pageItems.getAlertDialog(
          msg.toString(),
          () {
            Navigator.of(context).pop();
            if (onExit != null) {
              onExit();
            }
          },
        );
      },
    );
    print(msg.toString());
  }
}
