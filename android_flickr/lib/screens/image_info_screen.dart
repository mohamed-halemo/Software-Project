//out of the box imports
import 'package:flutter/material.dart';
//packages and plugins
import 'package:android_flickr/providers/flickr_post.dart';
import 'package:intl/intl.dart';

///A page that displays info of the Current Image
//ignore: must_be_immutable
class ImageInfoScreen extends StatefulWidget {
  ///Post Details , holds information about the image such as title, description, tags and so on.
  PostDetails postDetails;

  ///Constructor, takes PostDetails
  ImageInfoScreen(this.postDetails);
  @override
  ImageInfoScreenState createState() => ImageInfoScreenState();
}

///Image Info State Object
class ImageInfoScreenState extends State<ImageInfoScreen> {
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
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.postDetails.caption,
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
                  'DESCRIPTION',
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
                  widget.postDetails.description,
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
                  DateFormat('EEEE-MMM-d   HH:mm:ss')
                      .format(widget.postDetails.dateTaken),
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
              GestureDetector(
                onTap: () {},
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
                            width: MediaQuery.of(context).size.width * 0.2,
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
                            width: MediaQuery.of(context).size.width * 0.2,
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
