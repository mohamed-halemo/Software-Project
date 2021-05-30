import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import './pop_menu_button_of_post.dart';
import '../screens/non_profile_screen.dart';

/// A Widget that displays picPoster avatar, name, caption and since when was this post posted.
class PicPostedByInfoOnPost extends StatelessWidget {
  bool inPublicMode;

  ///
  /// Instance of post details that contains info about the post to set the info about faves and comments.
  final PostDetails postInformation;

  /// Helps me to diffrentiate whether I followed the user before/after running the app to select the widgets to display.
  bool isFollowedBeforeRunning = true;

  void _goToNonprofile(BuildContext ctx, PostDetails postInformation) {
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: postInformation,
    );
  }

  /// Returns the widget that will be displayed as subtitle in the listtile if it will be caption or Following recomended or recomended.
  Widget widgetToBeDisplayedAsSubtitle() {
    if (((postInformation.picPoster.isFollowedByUser &&
                !postInformation.picPoster.followedDuringRunning) ||
            inPublicMode) &&
        postInformation.caption != null) {
      return Text(postInformation.caption);
    } else if (((postInformation.picPoster.isFollowedByUser &&
                !postInformation.picPoster.followedDuringRunning) ||
            inPublicMode) &&
        postInformation.caption == null) {
      return Text("");
    } else if (postInformation.picPoster.followedDuringRunning) {
      isFollowedBeforeRunning = false;
      return Text("Following recomended");
    } else {
      isFollowedBeforeRunning = false;
      return Text("Recomended");
    }
  }

  /// Returns the widget that will be displayed as trailing in the listtile below whether it will be popup menu or posted since when.
  Widget widgetToBeDisplayedAsTrailing(double widthsize) {
    if ((postInformation.picPoster.isFollowedByUser &&
            !postInformation.picPoster.followedDuringRunning) ||
        inPublicMode) {
      return SizedBox(
        width: widthsize,
        child: Text(postInformation.postedSince),
      );
    } else if (postInformation.picPoster.followedDuringRunning) {
      return Text("");
    } else {
      /// Returns the popupmenubutton to display as trailing in listtile if needed.
      return PopupMenuButtonOfPost(postInformation);
    }
  }

  PicPostedByInfoOnPost(this.postInformation, this.inPublicMode);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () {
              _goToNonprofile(context, postInformation);
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 20,
              backgroundImage: NetworkImage(
                postInformation.picPoster.profilePicUrl,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            postInformation.picPoster.name,
          ),
          subtitle: widgetToBeDisplayedAsSubtitle(),
          trailing: widgetToBeDisplayedAsTrailing(
              MediaQuery.of(context).size.width / 10),
        ),
        if (!isFollowedBeforeRunning &&
            postInformation.caption != null &&
            !inPublicMode)
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 17),
              Text(
                postInformation.caption,
                textAlign: TextAlign.left,
              ),
            ],
          ),
      ],
    );
  }
}
