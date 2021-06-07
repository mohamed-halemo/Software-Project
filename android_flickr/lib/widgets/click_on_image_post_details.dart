import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import '../screens/image_info_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' show get;

import 'package:android_flickr/screens/photo_edit_screen.dart';

/// This class is responsible for all the features and widgets that will be displayed when we click on the post image.
class ClickOnImageDisplayPostDetails extends StatefulWidget {
  const ClickOnImageDisplayPostDetails({
    Key key,
    @required this.postInformation,
    @required this.isFromPersonalProfile,
  }) : super(key: key);

  final PostDetails postInformation;
  final bool isFromPersonalProfile;

  @override
  ClickOnImageDisplayPostDetailsState createState() =>
      ClickOnImageDisplayPostDetailsState();
}

class ClickOnImageDisplayPostDetailsState
    extends State<ClickOnImageDisplayPostDetails> {
  /// Returns a widget which tells me the string in Text widget that will be displayed based on the favesTotalNumber.
  Widget favesText(PostDetails postInformation) {
    if ((postInformation.favesDetails.favesTotalNumber > 1 ||
            postInformation.commentsTotalNumber != 0) &&
        postInformation.favesDetails.favesTotalNumber != 1) {
      return Text(
        '${postInformation.favesDetails.favesTotalNumber}' + ' faves',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else if (postInformation.favesDetails.favesTotalNumber == 1) {
      return Text(
        '${postInformation.favesDetails.favesTotalNumber}' + ' fave',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5.25,
      );
    }
  }

  /// Returns a widget which tells me the string in Text widget that will be displayed based on the commentsTotalNumber.
  Widget commentsText(PostDetails postInformation) {
    if ((postInformation.commentsTotalNumber > 1 ||
            postInformation.favesDetails.favesTotalNumber != 0) &&
        postInformation.commentsTotalNumber != 1) {
      return Text(
        '${postInformation.commentsTotalNumber}' + ' comments',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else if (postInformation.commentsTotalNumber == 1) {
      return Text(
        '${postInformation.commentsTotalNumber}' + ' comment',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5.25,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.25,
        ),
        if (widget.postInformation.caption != null)
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 17),
              Text(widget.postInformation.caption,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ],
          ),
        if (widget.postInformation.caption == null)
          Text(
            "",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.1,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            widget.isFromPersonalProfile
                ? IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      downloadImage(widget.postInformation);
                    },
                  )
                :

                /// Displays bottom bar which includes fave button, comment button, share button, info button and faves and comments total number
                IconButton(
                    icon: widget.postInformation.favesDetails.isFaved
                        ? Icon(
                            Icons.star,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.star_border_outlined,
                            color: Colors.white,
                          ),
                    onPressed: () {
                      setState(
                        () {
                          widget.postInformation.toggleFavoriteStatus();
                        },
                      );
                    },
                  ),
            IconButton(
              icon: Icon(
                Icons.comment_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ImageInfoScreen(
                        widget.postInformation, widget.isFromPersonalProfile),
                  ),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                favesText(widget.postInformation),
                commentsText(widget.postInformation),
              ],
            ),
          ],
        ),
      ],
    );
  }

  ///download image and go to edit screen
  void downloadImage(PostDetails postInformation) async {
    var _alertDownload = AlertDialog(
      content: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Downloading',
          style: TextStyle(
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (_) => _alertDownload,
      barrierDismissible: false,
    );
    Uri uri = Uri.parse(postInformation.postImageUrl);
    var response = await get(uri);
    var tempDir = await getTemporaryDirectory();
    var firstPath = tempDir.path + "/images";
    var filePathAndName = tempDir.path + '/images/pic.jpg';
    await Directory(firstPath).create(recursive: true).then(
      (value) {
        File file = new File(filePathAndName);
        file.writeAsBytesSync(response.bodyBytes);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                PhotoEditScreen(filePathAndName, true, 0),
          ),
        );
      },
    );
  }
}
