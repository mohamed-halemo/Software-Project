import 'package:android_flickr/providers/flickr_profiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_post.dart';
import './pop_menu_button_of_post.dart';
import '../screens/non_profile_screen.dart';
import '../providers/flickr_posts.dart';

/// A Widget that displays picPoster avatar, name, caption and since when was this post posted.
// ignore: must_be_immutable
class PicPostedByInfoOnPost extends StatelessWidget {
  bool inPublicMode;

  ///
  /// Instance of post details that contains info about the post to set the info about faves and comments.
  final PostDetails postInformation;

  /// Helps me to diffrentiate whether I followed the user before/after running the app to select the widgets to display.
  bool isFollowedBeforeRunning = true;

  /// When circle avatar or name is pressed then the app navigates to this user and sends its details(post information) and other posts
  /// and profiles to choose the posts and images needed and display them.
  void _goToNonprofile(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> currentPosts, FlickrProfiles flickrProfiles) {
    final flickrProfileDetails = flickrProfiles.addProfileDetailsToList(
        postInformation.picPoster, currentPosts);
    /* final flickrProfileDetails = FlickrProfiles().profiles.where(
        (profile) => profile.profileID == postInformation.picPoster.profileId); */
    // print(flickrProfileDetails.profileID);
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: [postInformation, flickrProfileDetails],
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
    /*   print("/*");
    print(postInformation.picPoster.isFollowedByUser);
    print(postInformation.postedSince);
    print("*/"); */
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
    final flickrProfiles = Provider.of<FlickrProfiles>(context);
    final currentPosts = Provider.of<Posts>(context).posts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () {
              _goToNonprofile(
                  context, postInformation, currentPosts, flickrProfiles);
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
