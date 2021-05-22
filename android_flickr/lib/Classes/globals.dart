library my_prj.globals;

bool isMockService = false;

class HttpSingleton {
  static final HttpSingleton _singleton = HttpSingleton._internal();

  factory HttpSingleton() {
    return _singleton;
  }

  HttpSingleton._internal();

  String getBaseUrl() {
    return isMockService == true ? '10.0.2.2:3000' : 'https://fotone.me/api';
  }
}
