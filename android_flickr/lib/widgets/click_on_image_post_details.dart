import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';

class ClickOnImageDisplayPostDetails extends StatefulWidget {
  const ClickOnImageDisplayPostDetails({
    Key key,
    @required this.postInformation,
  }) : super(key: key);

  final PostDetails postInformation;

  @override
  _ClickOnImageDisplayPostDetailsState createState() =>
      _ClickOnImageDisplayPostDetailsState();
}

class _ClickOnImageDisplayPostDetailsState
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
              onPressed: () {},
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
}
