library my_prj.globals;

import 'package:http/http.dart';
import 'dart:convert';

bool isMockService = false;

class HttpSingleton {
  static final HttpSingleton _singleton = HttpSingleton._internal();

  factory HttpSingleton() {
    return _singleton;
  }

  HttpSingleton._internal();

  String getBaseUrl() {
    return isMockService == true
        ? '10.0.2.2:3000'
        : 'mockservice-zaka-default-rtdb.firebaseio.com';
  }
}
