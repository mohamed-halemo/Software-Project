///Globals library, has global varibles as well as http handler singleton,
/// used for dependancy injection
library my_prj.globals;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

///If true, mockService Url is used, if false, Real Server is used
bool isMockService = false;

String accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjIyNTM4NjQxLCJqdGkiOiIxMjdhMjA1YWEzNGU0ZGViODA5YTg4ZWI4Y2ZhOTQzYiIsInVzZXJfaWQiOjF9.BMgB9o1N2p6s_a8-quUXPCM-v_p5N2AChtYp53PXEbo';
String refreshToken = '';

String email;
String password;

///http handler for the project. It is a singleton.
class HttpSingleton {
  static final HttpSingleton _singleton = HttpSingleton._internal();

  factory HttpSingleton() {
    return _singleton;
  }

  HttpSingleton._internal();

  ///Returns the base url of the server APIs, returns mock url if isMockService is true.
  String getBaseUrl() {
    return isMockService == true ? '10.0.2.2:3000' : 'fotone.me';
  }

  Future<bool> tokenRefresh() async {
    var url = Uri.https(HttpSingleton().getBaseUrl(),
        isMockService ? '/login/' : 'api/accounts/api/token/refresh/');
    final response = await http.post(url,
        body: json.encode(
          {
            'refresh': refreshToken,
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      accessToken = data['access'];
      print('Token Refresh');
      return true;
    } else {
      var url = Uri.https(HttpSingleton().getBaseUrl(),
          isMockService ? '/login/' : 'api/accounts/login/');
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        accessToken = data['tokens']['access'];
        refreshToken = data['tokens']['refresh'];
        print('Token Login');
        return true;
      }
      print('failed');
    }
    return false;
  }
}
