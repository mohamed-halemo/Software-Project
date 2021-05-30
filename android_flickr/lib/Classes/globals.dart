///Globals library, has global varibles as well as http handler singleton,
/// used for dependancy injection
library my_prj.globals;

///If true, mockService Url is used, if false, Real Server is used
bool isMockService = false;

String accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjIyNDA0Njc3LCJqdGkiOiJmYTZlYzAzMWFhZDQ0OWI1ODE1NDMzNzVmNmUwZmE4ZiIsInVzZXJfaWQiOjE3fQ.BWaAkbBLkxERDRDmcFZarNmc8Rrd1J_jchwXYpqJiGE';
String refreshToken = '';

///http handler for the project. It is a singleton.
class HttpSingleton {
  static final HttpSingleton _singleton = HttpSingleton._internal();

  factory HttpSingleton() {
    return _singleton;
  }

  HttpSingleton._internal();

  ///Returns the base url of the server APIs, returns mock url if isMockService is true.
  String getBaseUrl() {
    return isMockService == true
        ? 'http://10.0.2.2:3000'
        : 'https://fotone.me/api';
  }
}
