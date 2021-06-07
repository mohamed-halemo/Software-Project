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
  List<PostDetails> _cameraRollPosts = [];

  /// List of other profiles that have posts which is used in search mode.
  List<PicPosterDetails> _picPosterProfilesDetails = [];

  ///Used to fetch data from the main database or mock service based on boolean isMockService and set them in the List of posts.
  ///
  ///If isMockService = true, then fetch data from mock service.
  ///If isMockService = false, then fetch data from main database.
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
        await mianServerMyPosts();
      }
    } catch (error) {
      throw (error);
    }
    // print("done fetching");
  }

  /// If isMockService = false then, this function is called to fetch data from the main server.
  Future<void> mainServerExplorePosts() async {
    //fetchAndSetMyPosts();
    final url =
        Uri.https(globals.HttpSingleton().getBaseUrl(), 'api/photos/home');
    //print(url);
    final myInfoUrl = Uri.https(
        globals.HttpSingleton().getBaseUrl(), 'api/accounts/user-info');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      final myInfoResponse = await http.get(
        myInfoUrl,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      //print(myInfoResponse.body);
      final extractedMyInfo =
          json.decode(myInfoResponse.body) as Map<String, dynamic>;
      final myId = extractedMyInfo['id'];
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final followingPosts =
          extractedData['results']['following_photos'] as List<dynamic>;
      final publicPosts =
          extractedData['results']['public_photos'] as List<dynamic>;

      final loadedFollowPosts = setPostsFromMainserver(followingPosts, myId);
      final loadedPublicPosts = setPostsFromMainserver(publicPosts, myId);
      //print(loadedFollowPosts.length);
      //print(loadedPublicPosts.length);
      //print("start");
      //print(followingPosts.length);
/*       final List<PostDetails> loadedPosts = [];
      final List<PicPosterDetails> loadedPicPosterProfiles = [];
      final List<String> loadedPicPosterProfilesIds = [];
      //final List<String> loadedProfilesId = [];
      followingPosts.forEach(
        (postDetails) {
          //print(postDetails);
          //int postUrl = postDetails['id'] * 2;
          //print(postDetails['title']);
          //print(postDetails['title'].length);
          var dateNow = DateTime.now();
          dateNow = DateFormat('dd-MM-yyyy')
              .parse(DateFormat('dd-MM-yyyy').format(dateNow));

          final difference = dateNow
              .difference(
                  DateFormat('dd-MM-yyyy').parse(postDetails['date_posted']))
              .inDays;
          //print();
          print(dateNow);
          print(DateFormat('dd-MM-yyyy').parse(postDetails['date_posted']));
          print(difference);
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
                postDetails['owner']['is_followed']
                    ? false
                    : true, //not found, using placeholder for is_followed_by_user
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id']}', //found
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id'] * 3}', //found
              ),
            );
          }
          List<String> peopleFaved = [];
          final getFavedNames = postDetails['favourites'] as List<dynamic>;
          //print(getFavedNames[0]['first_name']);
          getFavedNames.forEach((user) {
            String addName =
                user['first_name'] + ' ' + user['last_name'] as String;
            peopleFaved.add(addName);
          });
          //print(peopleFaved.length);
          if (postDetails['is_faved']) {
            peopleFaved.insert(0, 'You');
          }
          loadedPosts.add(
            PostDetails(
              id: postDetails['id'].toString(), //found
              commentsTotalNumber: postDetails['count_comments'], //found
              favesDetails: FavedPostDetails(
                favedUsersNames: peopleFaved, //found
                isFaved: postDetails['is_faved'], //found
                favesTotalNumber: postDetails['count_favourites'], //found
              ),
              picPoster: PicPosterDetails(
                postDetails['owner']['id'].toString(), //found
                (postDetails['owner']['first_name'] +
                    " " +
                    postDetails['owner']['last_name']), //found
                postDetails['owner']['is_pro'], //found
                postDetails['owner']['is_followed'],
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id']}', //found
                'https://picsum.photos/200/200?random=' +
                    '${postDetails['owner']['id'] * 3}', //found
              ),
              postImageUrl:
                  'https://fotone.me' + postDetails['media_file'], //found
              postedSince: "DateFormat().parse(postDetails['date_posted'])",
              caption: postDetails['title'].length > 0
                  ? postDetails['title']
                  : " ", //found
              lastComment: {
                "postDetails['lastCommentUser']":
                    " postDetails['photo_comments'][postDetails['photo_comments']]", //found
              },
              tags: postDetails['photo_tags'], //found

              description: postDetails['description'], //found
              privacy: postDetails['is_public'], //found
              dateTaken: DateFormat('dd-MM-yyyy')
                  .parse(postDetails['date_posted']), //found
            ),
          );
        },
      ); */
      //print(loadedProfilesId.length);
      _posts.clear();
      loadedFollowPosts.forEach((post) {
        _posts.add(post);
      });
      loadedPublicPosts.forEach((post) {
        _posts.add(post);
      });
      //print(_posts.length);
      //_posts = loadedPosts;

      // print("check profile count");
      // print(_picPosterProfilesDetails.length);

      notifyListeners();
    } catch (error) {
      // print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  Future<void> mianServerMyPosts() async {
    final url = Uri.https(
        globals.HttpSingleton().getBaseUrl(), 'api/photos/publiclogged');
    //print(url);

    final myInfoUrl = Uri.https(
        globals.HttpSingleton().getBaseUrl(), 'api/accounts/user-info');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      final myInfoResponse = await http.get(
        myInfoUrl,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      //print(myInfoResponse.body);
      final extractedMyInfo =
          json.decode(myInfoResponse.body) as Map<String, dynamic>;
      final myId = extractedMyInfo['id'];
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      /* final followingPosts =
          extractedData['results']['following_photos'] as List<dynamic>; */
      final publicPosts = extractedData['results']['photos'] as List<dynamic>;

      final loadedPublicPosts = setPostsFromMainserver(publicPosts, myId);
      //print(loadedFollowPosts.length);
      //(loadedPublicPosts.length);
      _myPosts.clear();
      loadedPublicPosts.forEach((post) {
        _myPosts.add(post);
      });

      /*  _posts.clear();
      loadedFollowPosts.forEach((post) {
        _posts.add(post);
      });
      loadedPublicPosts.forEach((post) {
        _posts.add(post);
      });
      print(_posts.length); */
      //_posts = loadedPosts;

      // print("check profile count");
      // print(_picPosterProfilesDetails.length);

      notifyListeners();
    } catch (error) {
      // print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  List<PostDetails> setPostsFromMainserver(List<dynamic> posts, dynamic myId) {
    final List<PostDetails> loadedPosts = [];
    final List<PicPosterDetails> loadedPicPosterProfiles = [];
    final List<String> loadedPicPosterProfilesIds = [];
    //final List<String> loadedProfilesId = [];
    posts.forEach(
      (postDetails) {
        //print(postDetails);
        //int postUrl = postDetails['id'] * 2;
        //print(postDetails['title']);
        //print(postDetails['title'].length);
        var dateNow = DateTime.now();
        dateNow = DateFormat('dd-MM-yyyy')
            .parse(DateFormat('dd-MM-yyyy').format(dateNow));

        final difference = dateNow
            .difference(
                DateFormat('dd-MM-yyyy').parse(postDetails['date_posted']))
            .inDays;
        //print();
        //print(dateNow);
        //print(DateFormat('dd-MM-yyyy').parse(postDetails['date_posted']));
        //print(difference);
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
                  'is_followed'], //not found, using placeholder for is_followed_by_user
              'https://picsum.photos/200/200?random=' +
                  '${postDetails['owner']['id']}', //found
              'https://picsum.photos/200/200?random=' +
                  '${postDetails['owner']['id'] * 3}', //found
            ),
          );
        }
        List<String> peopleFaved = [];
        final getFavedNames = postDetails['favourites'] as List<dynamic>;
        //print(getFavedNames[0]['first_name']);
        bool is_faved = false;
        getFavedNames.forEach((user) {
          if (myId == user['id']) {
            is_faved = true;
            peopleFaved.insert(0, 'You');
          } else {
            String addName =
                user['first_name'] + ' ' + user['last_name'] as String;
            peopleFaved.add(addName);
          }
        });
        //print(peopleFaved.length);
        //if (postDetails['owner']['id'] == 8) {}
        
        loadedPosts.add(
          PostDetails(
            id: postDetails['id'].toString(), //found
            commentsTotalNumber: postDetails['count_comments'], //found
            favesDetails: FavedPostDetails(
              favedUsersNames: peopleFaved, //found
              isFaved: is_faved, //postDetails['is_faved'], //found

              favesTotalNumber: postDetails['count_favourites'], //found
            ),
            picPoster: PicPosterDetails(
              postDetails['owner']['id'].toString(), //found
              (postDetails['owner']['first_name'] +
                  " " +
                  postDetails['owner']['last_name']), //found
              postDetails['owner']['is_pro'], //found
              postDetails['owner']['is_followed'],
              'https://picsum.photos/200/200?random=' +
                  '${postDetails['owner']['id']}', //found
              'https://picsum.photos/200/200?random=' +
                  '${postDetails['owner']['id'] * 3}', //found
            ),
            postImageUrl:
                'https://fotone.me' + postDetails['media_file'], //found
            postedSince: "DateFormat().parse(postDetails['date_posted'])",
            caption: postDetails['title'].length > 0
                ? postDetails['title']
                : " ", //found
            lastComment: {
              "postDetails['lastCommentUser']":
                  " postDetails['photo_comments'][postDetails['photo_comments']]", //found
            },
            tags: postDetails['photo_tags'], //found

            description: postDetails['description'], //found
            privacy: postDetails['is_public'], //found
            dateTaken: DateFormat('dd-MM-yyyy')
                .parse(postDetails['date_posted']), //found
          ),
        );
      },
    );
    _picPosterProfilesDetails.clear();
    loadedPicPosterProfiles.forEach((element) {
      _picPosterProfilesDetails.add(element);
    });
    _picPosterProfilesDetails = loadedPicPosterProfiles;
    return loadedPosts;
  }

  /// Gets the posts of other profiles when using mock service from JSON server and set then in _posts if isMockService = false.
  Future<void> mockServiceExplorePosts() async {
    final url =
        Uri.http(globals.HttpSingleton().getBaseUrl(), '/Explore_posts');
    //print(url);

    try {
      ///Get the data from the service.
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as List<dynamic>;

      ///Posts from server are added to loadedPosts.
      final List<PostDetails> loadedPosts = [];

      ///Profiles from server/service are added to this list.
      final List<PicPosterDetails> loadedPicPosterProfiles = [];

      ///Helps to check if we added the user to loadedPicPosterProfiles or no.
      final List<String> loadedPicPosterProfilesIds = [];

      extractedData.forEach(
        (postDetails) {
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
      // print("check profile count");
      // print(_picPosterProfilesDetails.length);
      //FlickrProfiles.profilesId = loadedProfilesId;
      //print(loadedProfiles[1].profileName);
      //print(loadedProfiles[51].profileID);
      notifyListeners();
    } catch (error) {
      // print("error");
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
      // print(_myPosts.length);

      //FlickrProfiles.profilesId = loadedProfilesId;
      //print(loadedProfiles[1].profileName);
      //print(loadedProfiles[51].profileID);
      notifyListeners();
    } catch (error) {
      // print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  Future<void> mianServerCameraRoll() async {
    final url = Uri.https(
        globals.HttpSingleton().getBaseUrl(), 'api/photos/photoslogged');
    //print(url);

    final myInfoUrl = Uri.https(
        globals.HttpSingleton().getBaseUrl(), 'api/accounts/user-info');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      final myInfoResponse = await http.get(
        myInfoUrl,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
        },
      );
      //print(myInfoResponse.body);
      final extractedMyInfo =
          json.decode(myInfoResponse.body) as Map<String, dynamic>;
      final myId = extractedMyInfo['id'];
      //print(response.body);
      /* final extractedData =
          json.decode(response.body) as List<Map<String, dynamic>>; */
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      /* final followingPosts =
          extractedData['results']['following_photos'] as List<dynamic>; */
      final publicPosts = extractedData['results']['photos'] as List<dynamic>;

      final loadedPublicPosts = setPostsFromMainserver(publicPosts, myId);
      //print(loadedFollowPosts.length);
      //print(loadedPublicPosts.length);
      _cameraRollPosts.clear();
      loadedPublicPosts.forEach((post) {
        _cameraRollPosts.add(post);
      });

      /*  _posts.clear();
      loadedFollowPosts.forEach((post) {
        _posts.add(post);
      });
      loadedPublicPosts.forEach((post) {
        _posts.add(post);
      });
      print(_posts.length); */
      //_posts = loadedPosts;

      // print("check profile count");
      // print(_picPosterProfilesDetails.length);

      notifyListeners();
    } catch (error) {
      // print("error");
      //print('https://picsum.photos/200/200?random=' + '$postUrl');
      throw (error);
    }
  }

  ///Returns copy of the List of posts.
  List<PostDetails> get posts {
    //print(_posts);
    return [..._posts];
  }

  ///Returns copy of the List of the user posts.
  List<PostDetails> get myPosts {
    //print(_posts);
    return [..._myPosts];
  }

  ///Returns copy of the List of the Camera roll posts.
  List<PostDetails> get cameraRollPosts {
    //print(_posts);
    return [..._cameraRollPosts];
  }

  /// Returns list of all users that posted on flickr.
  List<PicPosterDetails> get picPosterProfilesDetails {
    //print(_posts);
    return [..._picPosterProfilesDetails];
  }
}

/* String postedSince(DateTime date) {
  if (DateFormat.y(date) != DateFormat.y(DateTime.now())) {
    return '';
  } else if (DateFormat.M(date) != DateFormat.M(DateTime.now())) {
    return '';
  } else if (DateFormat.d(date) != DateFormat.d(DateTime.now())) {
    return '';
  }
} */
