import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';

/// A widget that displays few information about the comment(last comment) and one or two names if availabe of the users who faved the post
class FewDetailsOfFavesComments extends StatelessWidget {
  final PostDetails postInformation;

  /// Instance of post details that contains info about the post
  FewDetailsOfFavesComments(this.postInformation);

  /// Gettter used to return string that contains the names of one or two users who faved ,if availabe
  ///
  /// ```dart
  /// You, ahmed and 5869 others faved, or
  /// ahmed faved
  /// ```
  String get favesNames {
    String names;
    if (postInformation.favesDetails.favedUsersNames.length == 1) {
      return postInformation.favedUsersNamesCopy[0] + ' faved';
    } else if (postInformation.favesDetails.favedUsersNames.length == 2 &&
        postInformation.favesDetails.favesTotalNumber < 3) {
      names = postInformation.favedUsersNamesCopy[0] +
          ' and ' +
          postInformation.favedUsersNamesCopy[1] +
          ' faved';
      return names;
    } else {
      names = postInformation.favedUsersNamesCopy[0] +
          ', ' +
          postInformation.favedUsersNamesCopy[1] +
          ' and ${postInformation.favesDetails.favesTotalNumber - 2} others faved';
      return names;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: <Widget>[
          if (postInformation.favesDetails.favesTotalNumber != 0)
            ListTile(
              leading: Icon(
                Icons.star,
                size: 15,
              ),
              title: Text(
                favesNames,
                style: TextStyle(),
                softWrap: true,
              ),
            ),
          if (postInformation.commentsTotalNumber != 0)
            ListTile(
              leading: Icon(
                Icons.comment,
                size: 15,
              ),
              title: Text(
                postInformation.lastComment.keys.first,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
              subtitle: Text(
                postInformation.lastComment.values.first,
                style: TextStyle(),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              trailing: Text(
                postInformation.commentsTotalNumber.toString() +
                    " of " +
                    postInformation.commentsTotalNumber.toString(),
              ),
            ),
        ],
      ),
    );
  }
}
