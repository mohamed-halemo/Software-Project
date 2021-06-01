//import 'package:android_flickr/providers/flickr_profiles.dart';

import 'package:intl/intl.dart';
import 'dart:io';
import './flickr_post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../Classes/globals.dart' as globals;

///Class Posts is used to obtain lists of class post in order to display these posts on our explore screen.
class Posts with ChangeNotifier {
  ///List of other users profiles posts.
  List<PostDetails> _posts = [];

  ///List of user profile posts.
  List<PostDetails> _myPosts = [];

  /// List of other profiles that have posts which is used in search mode.
  List<PicPosterDetails> _picPosterProfilesDetails = [];

  /* Future<void> _addPostsToDatabase() async {
    final url = Uri.https(
        'https://flickr-explore-default-rtdb.firebaseio.com', '/posts.json');
    await http.post(
      url,
      body: json.encode(
        {
          'commentsTotalNumber': 80,
          'lastComment': {
            'Ahmed elghandoor': 'what a great picture!,lets enjoy this weather',
          },
          'postImageUrl':
              'assets/images/GetStartedScreens/GetStartedScreenSlide1.png',
          'postedSince': '6d',
          'caption': "nice weather",
          'favesDetails': {
            'favesTotalNumber': [],
            'favedUsersNames': [],
            'bool isFaved': []
          },
          'PicPosterDetails': {
            'name': [],
            'isPro': [],
            'isFollowedByUser': [],
            'profilePicUrl': [],
          }
        },
      ),
    );
  } */

  ///Used to fetch data from the firebase database and set them in the List of posts.
  Future<void> fetchAndSetExplorePosts() async {
    /* final url = Uri.https(
        'flickr-explore-default-rtdb.firebaseio.com', '/ExplorePosts.json'); */
    //const url = 'https://flutter-update.firebaseio.com.json';
    try {
      if (globals.isMockService) {
        await fetchAndSetMyPosts();
        await mockServiceExplorePosts();
      } else {
        await mainServerExplorePosts();
      }
    } catch (error) {
      throw (error);
    }
    print("done fetching");
  }

  Future<void> mainServerExplorePosts() async {
    /* final url = Uri.https(
        'flickr-explore-default-rtdb.firebaseio.com', '/ExplorePosts.json'); */
    //const url = 'https://flutter-update.firebaseio.com.json';
    //fetchAndSetMyPosts();
    final url =
        Uri.http(globals.HttpSingleton().getBaseUrl(), 'api/photos/home');
    //print(url);

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extactedposts =
          extractedData['results']['public_photos'] as List<dynamic>;
      //print("start");
      //print(extactedposts);
      final List<PostDetails> loadedPosts = [];
      final List<PicPosterDetails> loadedPicPosterProfiles = [];
      final List<String> loadedPicPosterProfilesIds = [];
      //final List<String> loadedProfilesId = [];
      extactedposts.forEach(
        (postDetails) {
          //print(postDetails);
          //int postUrl = postDetails['id'] * 2;
          //print(postDetails['title']);
          //print(postDetails['title'].length);
          if (!loadedPicPosterProfilesIds.contains(
            postDetails['owner']['id'].toString(),
          )) {
            loadedPicPosterProfilesIds.add(
              postDetails['owner']['id'].toString(),
            );
            loadedPicPosterProfiles.add(
              PicPosterDetails(
                postDetails['owner']['id'].toString(), //found
                (postDetails['owner']['first_name'] +
                    " " +
                    postDetails['owner']['last_name']), //found
                postDetails['owner']['is_pro'], //found
                postDetails['owner'][
                    'is_staff'], //not found, using placeholder for is_followed_by_user
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id']}', //found
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id'] * 3}', //found
              ),
            );
          }
          loadedPosts.add(
            PostDetails(
              id: postDetails['id'].toString(), //found
              commentsTotalNumber: postDetails['count_comments'], //found
              favesDetails: FavedPostDetails(
                favedUsersNames: postDetails['is_faved'] //found
                    ? [
                        'You',
                        'postDetails[favourites][1]', //found
                        'postDetails[favourites][2]', //found
                      ]
                    : [
                        'postDetails[favourites][1]', //found
                        'postDetails[favourites][2]', //found
                      ],
                isFaved: postDetails['is_faved'], //found
                favesTotalNumber: postDetails['count_favourites'], //found
              ),
              picPoster: PicPosterDetails(
                postDetails['owner']['id'].toString(), //found
                (postDetails['owner']['first_name'] +
                    " " +
                    postDetails['owner']['last_name']), //found
                postDetails['owner']['is_pro'], //found
                postDetails['owner'][
                    'is_staff'], //not found, using placeholder for is_followed_by_user
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id']}', //found
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id'] * 3}', //found
              ),
              postImageUrl:
                  'https://fotone.me' + postDetails['media_file'], //found
              postedSince: postDetails['owner']['id'].toString(),
              caption: postDetails['title'].length > 0
                  ? postDetails['title']
                  : " ", //found
              lastComment: {
                "postDetails['lastCommentUser']":
                    " postDetails['photo_comments'][postDetails['photo_comments']]", //found
              },
              tags: "postDetails['photo_tags']", //found
              //dateTaken: postDetails['date_taken'],
              description: postDetails['description'], //found
              privacy: postDetails['is_public'], //found
              dateTaken: DateFormat('dd-MM-yyyy')
                  .parse(postDetails['date_posted']), //found
            ),
          );
        },
      );
      //print(loadedProfilesId.length);
      _posts = loadedPosts;
      _picPosterProfilesDetails = loadedPicPosterProfiles;
      print("check profile count");
      print(_picPosterProfilesDetails.length);

      notifyListeners();
    } catch (error) {
      print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  /// Gets the posts of other profiles when using mock service from JSON server and set then in _posts.
  Future<void> mockServiceExplorePosts() async {
    /* final url = Uri.https(
        'flickr-explore-default-rtdb.firebaseio.com', '/ExplorePosts.json'); */
    //const url = 'https://flutter-update.firebaseio.com.json';
    //fetchAndSetMyPosts();
    final url =
        Uri.http(globals.HttpSingleton().getBaseUrl(), '/Explore_posts');
    //print(url);

    try {
      final response = await http.get(url);
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as List<dynamic>;
      //print(extractedData);
      final List<PostDetails> loadedPosts = [];
      final List<PicPosterDetails> loadedPicPosterProfiles = [];
      final List<String> loadedPicPosterProfilesIds = [];

      extractedData.forEach(
        (postDetails) {
          /* if (!loadedProfilesId.contains(
            postDetails['ProfileId'].toString(),
          )) {
            loadedProfilesId.add(postDetails['ProfileId'].toString());
          }
 */
          int postUrl = postDetails['id'] * 2;
          //print(postUrl);
          /* String postUrl = 'https://picsum.photos/200/200?random=' +
              '${postDetails['id'] + 5}'; */
          //print(postDetailsId);

          if (!loadedPicPosterProfilesIds.contains(
            postDetails['ProfileId'].toString(),
          )) {
            loadedPicPosterProfilesIds.add(
              postDetails['ProfileId'].toString(),
            );
            loadedPicPosterProfiles.add(
              PicPosterDetails(
                postDetails['ProfileId'].toString(),
                postDetails['PicPosterDetailsname'],
                postDetails['isPro'],
                postDetails['isFollowedByUser'],
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['ProfileId']}',
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['ProfileId'] * 3}',
              ),
            );
          }

          loadedPosts.add(
            PostDetails(
              id: postDetails['id'].toString(),
              commentsTotalNumber: postDetails['commentsTotalNumber'],
              favesDetails: FavedPostDetails(
                favedUsersNames: postDetails['isFaved']
                    ? [
                        'You',
                        postDetails['favedUsersNames1'],
                        postDetails['favedUsersNames2'],
                      ]
                    : [
                        postDetails['favedUsersNames1'],
                        postDetails['favedUsersNames2'],
                      ],
                isFaved: postDetails['isFaved'],
                favesTotalNumber: postDetails['favesTotalNumber'],
              ),
              picPoster: PicPosterDetails(
                postDetails['ProfileId'].toString(),
                postDetails['PicPosterDetailsname'],
                postDetails['isPro'],
                postDetails['isFollowedByUser'],
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['ProfileId']}',
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['ProfileId'] * 3}', //found
              ),
              postImageUrl:
                  'https://picsum.photos/200/200?random=' + '$postUrl',
              postedSince: postDetails['postedSince'],
              caption: postDetails['caption'],
              lastComment: {
                postDetails['lastCommentUser']: postDetails['lastCommentText'],
              },
              tags: postDetails['tags'],
              //dateTaken: postDetails['date_taken'],
              description: postDetails['description'],
              privacy: postDetails['privacy'],
              dateTaken:
                  DateFormat('dd-MMM-yyyy').parse(postDetails['date_taken']),
            ),
          );
        },
      );
      //print(loadedProfilesId.length);
      _posts = loadedPosts;
      _picPosterProfilesDetails = loadedPicPosterProfiles;
      print("check profile count");
      print(_picPosterProfilesDetails.length);
      //FlickrProfiles.profilesId = loadedProfilesId;
      //print(loadedProfiles[1].profileName);
      //print(loadedProfiles[51].profileID);
      notifyListeners();
    } catch (error) {
      print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  ///Used to fetch user posts and data from JSON server and set them in the List of _myPosts.
  Future<void> fetchAndSetMyPosts() async {
    /* final url = Uri.https(
        'flickr-explore-default-rtdb.firebaseio.com', '/ExplorePosts.json'); */
    //const url = 'https://flutter-update.firebaseio.com.json';
    final url = Uri.http(globals.HttpSingleton().getBaseUrl(), '/MyPosts');
    //print(url);
    try {
      final response = await http.get(url);
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as List<dynamic>;
      //print(extractedData);
      final List<PostDetails> loadedPosts = [];
      //final List<String> loadedProfilesId = [];
      extractedData.forEach(
        (postDetails) {
          /*  if (!loadedProfilesId.contains(
            postDetails['ProfileId'].toString(),
          )) {
            loadedProfilesId.add(postDetails['ProfileId'].toString());
          } */

          int postUrl = postDetails['id'] * 10;
          //print(postUrl);
          /* String postUrl = 'https://picsum.photos/200/200?random=' +
              '${postDetails['id'] + 5}'; */
          //print(postDetailsId);
          loadedPosts.add(
            PostDetails(
              id: postDetails['id'].toString(),
              commentsTotalNumber: postDetails['commentsTotalNumber'],
              favesDetails: FavedPostDetails(
                favedUsersNames: postDetails['isFaved']
                    ? [
                        'You',
                        postDetails['favedUsersNames1'],
                        postDetails['favedUsersNames2'],
                      ]
                    : [
                        postDetails['favedUsersNames1'],
                        postDetails['favedUsersNames2'],
                      ],
                isFaved: postDetails['isFaved'],
                favesTotalNumber: postDetails['favesTotalNumber'],
              ),
              picPoster: PicPosterDetails(
                "619",
                "Dragon Slayer",
                false,
                true,
                'https://picsum.photos/200/200?random=' + '${619}',
                'https://picsum.photos/200/200?random=' + '${619 * 3}', //found
              ),
              postImageUrl:
                  'https://picsum.photos/200/200?random=' + '$postUrl',
              postedSince: postDetails['postedSince'],
              caption: postDetails['caption'],
              lastComment: {
                postDetails['lastCommentUser']: postDetails['lastCommentText'],
              },
              tags: postDetails['tags'],
              //dateTaken: postDetails['date_taken'],
              description: postDetails['description'],
              privacy: postDetails['privacy'],
              dateTaken:
                  DateFormat('dd-MMM-yyyy').parse(postDetails['date_taken']),
            ),
          );
        },
      );
      //print(loadedProfilesId.length);
      _myPosts = loadedPosts;
      print(_myPosts.length);

      //FlickrProfiles.profilesId = loadedProfilesId;
      //print(loadedProfiles[1].profileName);
      //print(loadedProfiles[51].profileID);
      notifyListeners();
    } catch (error) {
      print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  ///Returns copy of the List of posts.
  List<PostDetails> get posts {
    //print(_posts);
    return [..._posts];
  }

  List<PostDetails> get myPosts {
    //print(_posts);
    return [..._myPosts];
  }

  List<PicPosterDetails> get picPosterProfilesDetails {
    //print(_posts);
    return [..._picPosterProfilesDetails];
  }
}
