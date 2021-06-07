//import 'package:android_flickr/widgets/explore_post.dart';

//import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import '../Classes/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Gridview that displays only the images of the user(currently using the device) posts in grid mode.
// ignore: must_be_immutable
class GroupsPhotoView extends StatefulWidget {
  int id;
  GroupsPhotoView(this.id);

  @override
  _GroupsPhotoViewState createState() => _GroupsPhotoViewState();
}

class _GroupsPhotoViewState extends State<GroupsPhotoView> {
  bool isInit = false;
  List<dynamic> groupPhotos;
  List<String> photoUrls = [];
  Future<void> initGroups() async {
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/login/' : 'api/group/${widget.id}/photos');
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
              ? '/login/'
              : 'api/photos/${groupPhotos[i]['id']}');
      print(url);
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      ).then((value) {
        print(value.statusCode);
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
