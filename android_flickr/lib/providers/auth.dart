import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Classes/globals.dart' as globals;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password, String firstname,
      String lastname, String age) async {
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/sign-up/' : 'api/accounts/sign-up/');
    final response = await http.post(url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'first_name': firstname,
            'last_name': lastname,
            'age': int.parse(age)
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(json.decode(response.body));
    //print(response.statusCode);
  }
}
