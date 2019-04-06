import 'package:ipl_betting_app/modules/bloc_models/bloc_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LoaderData {
  double value;
  String textMessage;
  LoaderData(this.textMessage, this.value);
  @override
  String toString() => textMessage;

  double toDouble() => value;
}

abstract class BlocBaseClass {
  final taskCompletionFlagReciever = BehaviorSubject<BlocResponse>();
  final errorReceiver = BehaviorSubject<String>();
  Sink<BlocResponse> get dataController;
  Sink<String> get _errorSink => errorReceiver.sink;
  Sink<BlocResponse> get _taskCompletionFlagSink =>
      taskCompletionFlagReciever.sink;

  final messageReceiver = BehaviorSubject<ActionMessage>();
  Sink<ActionMessage> get _messageSink => messageReceiver.sink;
  static const backButtonPressedFlag = "BackButtonPressed";

  onTaskCompleted<T>(String taskCompletionFlag, {T data}) {
    _taskCompletionFlagSink
        .add(BlocResponse<T>.done(pageFlag: taskCompletionFlag, data: data));
  }

  sendErrorMessage(error, {String pageFlag, bool streamToPage = true}) {
    if (streamToPage)
      dataController.add(BlocResponse.error(data: error, pageFlag: pageFlag));
    _errorSink.add(error == null ? "Some Error Occured!" : error.toString());
  }

  backButtonClicked<T>([T data]) {
    onTaskCompleted(BlocBaseClass.backButtonPressedFlag, data: data);
  }

  sendActionMessage(message, [onExit]) {
    dataController.add(BlocResponse.error(data: message));
    _messageSink
        .add(ActionMessage(message ?? "Click Ok to To Continue", onExit));
  }

  sendLoaderMessage(String message,
      {Sink<BlocResponse> controller, double value}) {
    controller = controller ?? dataController;
    controller.add(
        BlocResponse.loading(LoaderData(message ?? "Loading data...", value)));
  }

  @mustCallSuper
  dispose() {
    errorReceiver.close();
    messageReceiver.close();
    taskCompletionFlagReciever.close();
  }
}

class ActionMessage {
  String message;
  Function onExit;
  ActionMessage(this.message, this.onExit);

  @override
  String toString() => message;
}
