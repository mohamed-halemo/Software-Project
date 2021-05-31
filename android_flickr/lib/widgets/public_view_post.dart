import 'package:android_flickr/widgets/explore_post.dart';

import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_post.dart';
import '../providers/flickr_profiles.dart';

/// Public View displays the posts like the explore mode but the diffrence is there is posted since when instead of popup menu in the posts of unfollowed user.
class PublicViewPost extends StatelessWidget {
  /* FlickrProfile _goToNonprofile(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> currentPosts) {
    final flickrProfileDetails = FlickrProfiles()
        .addProfileDetailsToList(postInformation.picPoster, currentPosts);
    return flickrProfileDetails;
  } */

  @override
  Widget build(BuildContext context) {
    //final currentPosts = Provider.of<Posts>(context).posts;
    //final postInformation = Provider.of<PostDetails>(context);
    //final postsToDisplay = Provider.of<Posts>(context).posts;
    final postsToDisplay = Provider.of<FlickrProfile>(context).profilePosts;
    //print(postInformation.id);
    /* final postsToDisplay =
        _goToNonprofile(context, postInformation, currentPosts).profilePosts; */

    return ListView.builder(
      //controller: _controller,
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: postsToDisplay[index],

          /// True in explore post is to indicate that posts are displayed in public mode not explore mode.
          child: ExplorePost(true, index),
        );
      },
    );
  }
}
