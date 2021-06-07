import 'package:android_flickr/widgets/explore_post.dart';

import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../providers/flickr_post.dart';
//import '../providers/flickr_profiles.dart';

/// Public View displays the posts like the explore mode but the diffrence is there is posted since when instead of popup menu in the posts of unfollowed user.
class PublicViewPost extends StatelessWidget {
  final inPublicMode = true;
  final isProfile = true;
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
    final postsToDisplay = Provider.of<Posts>(context).myPosts;
    //print(postInformation.id);
    /* final postsToDisplay =
        _goToNonprofile(context, postInformation, currentPosts).profilePosts; */

    return postsToDisplay.length > 0
        ? ListView.builder(
            //controller: _controller,
            itemCount: postsToDisplay.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: postsToDisplay[index],

                /// True in explore post is to indicate that posts are displayed in public mode not explore mode.
                child: ExplorePost(inPublicMode, index, isProfile, false),
              );
            },
          )
        : Center(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width / 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 5.5,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey,
                          size: 50,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Share your pics!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Take a photo or make photos public from the Camera roll",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
