class FAException implements Exception {
  final _message;

  final _prefix;

  FAException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends FAException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadrequestException extends FAException {
  BadrequestException([message]) : super(message, "Invalid Request: ");
}

class InvalidInputException extends FAException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class DisabledSettingException extends FAException {
  DisabledSettingException([String message]) : super(message, "Setting Disabled: ");
}