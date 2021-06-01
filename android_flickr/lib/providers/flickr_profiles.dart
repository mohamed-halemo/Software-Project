import 'package:android_flickr/providers/flickr_post.dart';
// import 'package:android_flickr/providers/flickr_posts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyProfile with ChangeNotifier {
  String profileID = "619";
  String profileName = "Dragon Slayer";
  //List<PostDetails> profilePosts;
  String profilePicUrl = 'https://picsum.photos/200/200?random=' + '${619}';
  String profileCoverPhoto =
      'https://picsum.photos/200/200?random=' + '${619 * 3}';

  //MyProfile(this.profileID, this.profileName, this.profilePosts);

  Map<String, String> get getProfilePicCoverPhoto {
    return {
      'profilePic': profilePicUrl,
      'profileCoverPhoto': profileCoverPhoto,
    };
  }
}

class FlickrProfile with ChangeNotifier {
  String profileID;
  String profileName;
  List<PostDetails> profilePosts;

  FlickrProfile(this.profileID, this.profileName, this.profilePosts);
}

class FlickrProfiles with ChangeNotifier {
  static List<String> profilesId = [];

  List<FlickrProfile> profiles = [];

  FlickrProfile addProfileDetailsToList(
      PicPosterDetails picPoster, List<PostDetails> currentPosts) {
    //int counter = 0;
    final postsOfProfile =
        getPostsWithProfileId(picPoster.profileId, currentPosts);
    if (!profilesId.contains(picPoster.profileId)) {
      profilesId.add(picPoster.profileId);
      // print(postsOfProfile.length);
      // print(picPoster.profileId);
      // print(picPoster.name);
      profiles.add(
        FlickrProfile(
          picPoster.profileId,
          picPoster.name,
          postsOfProfile,
        ),
      );

      //print(postsOfProfile);

    }

    //profiles.singleWhere((element) => element.profileID == picPoster.profileId);
    /* print(FlickrProfile(
      picPoster.profileId,
      picPoster.name,
      postsOfProfile,
    ).profileID); */
    /* print(profiles.length);
    final profile1 = [
      ...profiles.where(
        (element) {
          print("id");
          print(element.profileID);
          return element.profileID == picPoster.profileId;
        },
      )
    ]; */
    //print(profile1);
    final profile = FlickrProfile(
      picPoster.profileId,
      picPoster.name,
      postsOfProfile,
    );
    //print("check");
    // print(profile.profileID);
    //print("/check");
    return profile;
  }

  List<PostDetails> getPostsWithProfileId(
      String profileID, List<PostDetails> currentPosts) {
    //print(profileID);
    //print(currentPosts);
    return [
      ...currentPosts.where((post) {
        /* if (post.picPoster.profileId == profileID) {
          print(post.picPoster.profileId);
        } */

        return post.picPoster.profileId == profileID;
        /* PostDetails(). */
      })
    ];
  }
}
