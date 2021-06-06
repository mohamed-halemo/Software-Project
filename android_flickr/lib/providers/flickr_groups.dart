import 'dart:convert';
import 'dart:io';
import 'package:android_flickr/models/flickr_groups.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Classes/globals.dart' as globals;
import 'dart:convert';

class YourGroups with ChangeNotifier {
  Map<String, dynamic> myJason;
  List<Map<String, dynamic>> adminSerializer;
  List<FlickrGroup> _myGroups = [];
  Future<void> mainServerMyGroups() async {
    _myGroups = [];
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/group/' : 'api/group/');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${globals.accessToken}'
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      myJason = json.decode(response.body);
      for (var i = 0; i < myJason['admin_serializer'].length; i++) {
        _myGroups.add(FlickrGroup(
          groupName: myJason['admin_serializer'][i]['group']['name'],
          discussionCount: myJason['admin_serializer'][i]['group']
              ['topic_count'],
          memberCount: myJason['admin_serializer'][i]['group']['member_count'],
          photoCount: myJason['admin_serializer'][i]['group']['pool_count'],
          id: myJason['admin_serializer'][i]['group']['id'],
        ));
      }
    }
  }

  List<FlickrGroup> get myGroups {
    return [..._myGroups];
  }
}
