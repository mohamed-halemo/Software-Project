import 'package:flutter/material.dart';
import '../Classes/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Displaying the groups photos in the photos section in the group view
class GroupsPhotoView extends StatefulWidget {
  ///Group id number
  int id;
  GroupsPhotoView(this.id);

  @override
  _GroupsPhotoViewState createState() => _GroupsPhotoViewState();
}

class _GroupsPhotoViewState extends State<GroupsPhotoView> {
  ///Checks if the photos view is initialize or not
  bool isInit = false;

  ///List of the photos in the group
  List<dynamic> groupPhotos;

  ///List of the photos urls
  List<String> photoUrls = [];
  Future<void> initGroups() async {
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/group/' : 'api/group/${widget.id}/photos');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
      },
    ).then((value) {
      groupPhotos = json.decode(value.body);
    });
    for (var i = 0; i < groupPhotos.length; i++) {
      var url = Uri.https(
          globals.HttpSingleton().getBaseUrl(),
          globals.isMockService
              ? '/group/'
              : 'api/photos/${groupPhotos[i]['id']}');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      ).then((value) {
        photoUrls.add(json.decode(value.body)['photo']['media_file']);
      });
    }
    setState(() {
      isInit = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initGroups();
  }

  @override
  Widget build(BuildContext context) {
    return !isInit
        ? Center(
            child: SpinKitRing(
              color: Colors.grey[800],
              lineWidth: 3,
            ),
          )
        : ListView.builder(
            itemCount: groupPhotos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(15),
                child: Image.network('https://fotone.me' + photoUrls[index]),
              );
            });
  }
}
