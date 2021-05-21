import 'package:android_flickr/providers/flickr_post.dart';
import 'package:flutter/material.dart';

class ImageInfoScreen extends StatefulWidget {
  PostDetails postDetails;

  ImageInfoScreen(this.postDetails);
  @override
  _ImageInfoScreenState createState() => _ImageInfoScreenState();
}

class _ImageInfoScreenState extends State<ImageInfoScreen> {
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
                height: 15,
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
              Row(
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
                  widget.postDetails.picPoster.isPro
                      ? SizedBox(
                          height: 16,
                          width: 55,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              side: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                height: 1,
                                wordSpacing: -1,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
