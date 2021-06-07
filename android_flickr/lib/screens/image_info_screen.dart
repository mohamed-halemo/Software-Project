//out of the box imports
import 'package:android_flickr/screens/add_tags_screen.dart';
import 'package:android_flickr/screens/edit_description_screen.dart';
import 'package:flutter/material.dart';
//packages and plugins
import 'package:android_flickr/providers/flickr_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

//personal imports
import 'edit_title_screen.dart';
import '../Classes/globals.dart' as globals;

///A page that displays info of the Current Image
//ignore: must_be_immutable
class ImageInfoScreen extends StatefulWidget {
  ///Post Details , holds information about the image such as title, description, tags and so on.
  PostDetails postDetails;
  bool isFromPersonalProfile;
  List<String> tagsList = [];

  ///Constructor, takes PostDetails
  ImageInfoScreen(
    this.postDetails,
    this.isFromPersonalProfile,
  );
  @override
  ImageInfoScreenState createState() => ImageInfoScreenState();
}

///Image Info State Object
class ImageInfoScreenState extends State<ImageInfoScreen> {
  @override
  void initState() {
    super.initState();

    if (!widget.postDetails.tags.isEmpty) {
      for (var i = 0; i < widget.postDetails.tags.length; i++) {
        widget.tagsList.add(widget.postDetails.tags[i]['tag_text']);
      }
      setState(() {});
    }
  }

  ///Main build method, Rebuilds with state update.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.isFromPersonalProfile)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditTitleScreen(widget.postDetails.id),
                      ),
                    );
                },
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'TITLE',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    widget.isFromPersonalProfile
                        ? Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 8,
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.postDetails.caption == ''
                      ? 'Add title'
                      : widget.postDetails.caption,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: widget.postDetails.caption == ''
                        ? Colors.grey.shade500
                        : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.isFromPersonalProfile)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditDescriptionScreen(
                          widget.postDetails.id,
                        ),
                      ),
                    );
                },
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'DESCRIPTION',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    widget.isFromPersonalProfile
                        ? Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 8,
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.isFromPersonalProfile
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.postDetails.description == ''
                            ? 'Add description'
                            : widget.postDetails.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: widget.postDetails.description == ''
                              ? Colors.grey.shade500
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'TAKEN BY',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  //testApi();
                },
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.postDetails.picPoster.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    widget.postDetails.picPoster.isPro
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 4,
                              ),
                              child: Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddTagsScreen(widget.tagsList),
                    ),
                  ).then((value) async {
                    for (var i = 0; i < widget.postDetails.tags.length; i++) {
                      if (!widget.tagsList
                          .contains(widget.postDetails.tags[i]['tag_text'])) {
                        int tagId = widget.postDetails.tags[i]['tag_id'];
                        var url = Uri.https(
                            globals.HttpSingleton().getBaseUrl(),
                            globals.isMockService
                                ? '/sign-up/'
                                : 'api/photos/tags/$tagId');
                        final response = await http.delete(url, headers: {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.authorizationHeader:
                              'Bearer ' + globals.accessToken,
                        }).then((value) {
                          print(value.statusCode);
                        });
                      }
                    }

                    for (var i = 0; i < widget.tagsList.length; i++) {
                      bool isContained = false;
                      for (var j = 0; j < widget.postDetails.tags.length; j++) {
                        if (widget.postDetails.tags[j]['tag_text'] ==
                            widget.tagsList[i]) {
                          isContained = true;
                        }
                      }
                      if (!isContained) {
                        int photoId = int.parse(widget.postDetails.id);
                        var url = Uri.https(
                            globals.HttpSingleton().getBaseUrl(),
                            globals.isMockService
                                ? '/sign-up/'
                                : 'api/photos/$photoId/tags');
                        final response = await http.post(
                          url,
                          body: json.encode(
                            {
                              'tag_text': widget.tagsList[i],
                            },
                          ),
                          headers: {
                            HttpHeaders.contentTypeHeader: 'application/json',
                            HttpHeaders.authorizationHeader:
                                'Bearer ' + globals.accessToken,
                          },
                        ).then((value) {
                          print(value.statusCode);
                        });
                      }
                    }
                    setState(() {
                      widget.tagsList = value;
                    });
                  });
                },
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tags',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    widget.isFromPersonalProfile
                        ? Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 10,
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.tagsList.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: widget.isFromPersonalProfile
                            ? Text(
                                'Add a tag',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              )
                            : Container(),
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        childAspectRatio: 2.4,
                        crossAxisCount: 5,
                      ),
                      itemCount: widget.tagsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.tagsList[index],
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.white,
                            width: 1,
                          )),
                          // child: OutlinedButton(
                          //   style: OutlinedButton.styleFrom(
                          //     primary: Colors.white,
                          //     side: BorderSide(
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   child: Text(
                          //     widget.postDetails.tags[index]['tag_text'],
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 10,
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          // ),
                        );
                      }),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'DATE TAKEN',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat('EEEE-MMM-d').format(widget.postDetails.dateTaken),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'MORE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ),
                child: widget.isFromPersonalProfile
                    ? PopupMenuButton(
                        shape: Border.all(
                          width: double.infinity,
                        ),
                        offset: Offset(0, 50),
                        onSelected: (value) async {
                          switch (value) {
                            case 1:
                              Uri url = Uri.https(
                                  globals.HttpSingleton().getBaseUrl(),
                                  '/api/photos/${widget.postDetails.id}/perms');

                              await http.put(
                                url,
                                body: json.encode(
                                  {'is_public': true},
                                ),
                                headers: {
                                  HttpHeaders.authorizationHeader:
                                      'Bearer ' + globals.accessToken,
                                  HttpHeaders.contentTypeHeader:
                                      'application/json'
                                },
                              ).then((value) {
                                if (value.statusCode == 200) {
                                  setState(() {
                                    widget.postDetails.privacy = true;
                                  });
                                }
                                print(value.statusCode);
                              });

                              break;
                            case 2:
                              Uri url = Uri.https(
                                  globals.HttpSingleton().getBaseUrl(),
                                  '/api/photos/${widget.postDetails.id}/perms');

                              await http.put(
                                url,
                                body: json.encode(
                                  {'is_public': false},
                                ),
                                headers: {
                                  HttpHeaders.authorizationHeader:
                                      'Bearer ' + globals.accessToken,
                                  HttpHeaders.contentTypeHeader:
                                      'application/json'
                                },
                              ).then((value) {
                                print(value.statusCode);
                                if (value.statusCode == 200) {
                                  setState(() {
                                    widget.postDetails.privacy = false;
                                  });
                                }
                              });
                              break;

                            default:
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          'Public',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 80,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 60,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          'Private',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 80,
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        child: Container(
                          child: widget.postDetails.privacy
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.lock_open,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Public',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                    ),
                                    Icon(
                                      Icons.image_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Private',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                    ),
                                    Icon(
                                      Icons.image_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    : Container(
                        child: widget.postDetails.privacy
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.lock_open,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Public',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Private',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    int photoId = int.parse(widget.postDetails.id);
                    var url = Uri.https(
                        globals.HttpSingleton().getBaseUrl(),
                        globals.isMockService
                            ? '/sign-up/'
                            : 'api/photos/$photoId');
                    final response = await http.delete(url, headers: {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.authorizationHeader:
                          'Bearer ' + globals.accessToken,
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete photo',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void testApi() {
  //   var urlUri = Uri.parse(globals.HttpSingleton().getBaseUrl() + '/gallery/');

  //   //https://fotone.me/api/gallery/1/comments
  //   print(HttpHeaders.authorizationHeader);

  //   http.get(
  //     urlUri,
  //     headers: {
  //       "Content-Type": "application/json",
  //       HttpHeaders.authorizationHeader: 'Bearer ' +
  //           'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjIxNjQwNjAyLCJqdGkiOiI4Mjk2ZDFjMjZhOTE0YTU1YmIyMWMxZmI2MzAyNzc2NCIsInVzZXJfaWQiOjF9.XL8IQzrg4KWDOXlMl3YNkXL8WGrpO3o1xrLSyo_28Vg'
  //     },

  //     //user
  //     //favs
  //     //gallery
  //     //contacts
  //     //
  //   ).then((value) {
  //     print(value.body);
  //     if (value.statusCode == 200) {
  //       var resp = value;
  //       json.decode(resp.body);
  //       print(resp.statusCode);
  //     }
  //   });
  // }
}
