import 'package:android_flickr/providers/flickr_post.dart';
// import 'package:android_flickr/providers/flickr_posts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Classes/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class PersonalProfile with ChangeNotifier {
  ///User ID
  final profileID;

  ///User First Name
  final firstName;

  ///User Last Name
  final lastName;

  ///Is User Pro User?
  final isPro;

  ///Total number of Photos of User
  final totalMedia;

  ///User Profile Picture Url
  final profilePicUrl;

  ///User Profile Cover Picture Url
  final profileCoverPicUrl;

  ///Number of Users following User
  final followersCount;

  ///Number of Users User Follows
  final followingCount;

  PersonalProfile({
    @required this.profileID,
    @required this.firstName,
    @required this.lastName,
    @required this.isPro,
    @required this.totalMedia,
    @required this.profileCoverPicUrl,
    @required this.profilePicUrl,
    @required this.followersCount,
    @required this.followingCount,
  });
}

class MyProfile with ChangeNotifier {
  Map<String, dynamic> jsonResponse;
  PersonalProfile _myProfile;

  ///
  Future<void> fetchMyProfileInfo() async {
    var url = Uri.https(globals.HttpSingleton().getBaseUrl(),
        globals.isMockService ? '/group/' : 'api/accounts/user-info/');
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${globals.accessToken}'
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 401) {
      globals.HttpSingleton().tokenRefresh();
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${globals.accessToken}'
        },
      );
    }
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      _myProfile = new PersonalProfile(
          profileID: jsonResponse['id'],
          firstName: jsonResponse['first_name'],
          lastName: jsonResponse['last_name'],
          isPro: jsonResponse['is_pro'],
          totalMedia: jsonResponse['total_media'],
          profileCoverPicUrl: jsonResponse['cover_photo'],
          profilePicUrl: jsonResponse['profile_pic'],
          followersCount: jsonResponse['followers_count'],
          followingCount: jsonResponse['following_count']);
    }
  }

  PersonalProfile get myProfile {
    return _myProfile;
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
