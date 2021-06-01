///Globals library, has global varibles as well as http handler singleton,
/// used for dependancy injection
library my_prj.globals;

///If true, mockService Url is used, if false, Real Server is used
bool isMockService = true;

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
        ? '192.168.1.10:3000'
        : 'https://fotone.me/api';
  }
}
//'10.0.2.2:8000'
//json-server --host 192.168.1.X db.json
