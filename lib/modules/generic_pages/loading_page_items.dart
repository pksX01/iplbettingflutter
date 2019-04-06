import 'package:flutter/material.dart';

class LoadingPageItems {
  static final LoadingPageItems _singleton = new LoadingPageItems._internal();
  LoadingPageItems._internal();
  factory LoadingPageItems() {
    return _singleton;
  }

  Widget getLoaderPage() {
    return CircularProgressIndicator();
  }
}
