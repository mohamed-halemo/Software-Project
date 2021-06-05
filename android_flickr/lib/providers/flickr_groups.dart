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
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/group/' : 'api/group/');
    final response = await http
        .get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      myJason = json.decode(response.body);
      adminSerializer = myJason['admin_serializer'];
      print(myJason);
      for (var i = 0; i < adminSerializer.length; i++) {
        _myGroups.add(FlickrGroup(
            discussionCount: adminSerializer[i]['group']['topic_count'],
            groupName: adminSerializer[i]['group']['name'],
            memberCount: adminSerializer[i]['group']['member_count'],
            photoCount: adminSerializer[i]['group']['pool_count']));
      }
    }
  }

  List<FlickrGroup> get myGroups {
    return [..._myGroups];
  }
}
