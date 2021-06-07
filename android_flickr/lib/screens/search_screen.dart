import 'package:android_flickr/widgets/search_groups.dart';
import 'package:android_flickr/widgets/search_people.dart';
import 'package:android_flickr/widgets/search_photos.dart';
import '../providers/flickr_posts.dart';
import '../providers/flickr_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Classes/globals.dart' as globals;
// import '../Classes/globals.dart' as globals;

/// When the search textfield is pressed in the search tab on explore screen, this screen is displayed with textfield for the user to search for group/photo/people.
class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  ///Contains the text that the user is searching for.
  final searchTextController = TextEditingController();

  /// Contains the List of photos that will be displayed on photo tab.
  List<PostDetails> photosSearchResult = [];

  /// Contains the List of people that will be displayed on people tab.
  List<PicPosterDetails> peopleSearchResult = [];

  ///
  Future<void> getPhotosSearchResultMainServer(Posts postsPointer) async {
    Dio dio = new Dio(
      BaseOptions(
        baseUrl: 'https://' + globals.HttpSingleton().getBaseUrl(),
      ),
    );
    dio.options.headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
    };
    var extractedData;

    try {
      await dio.get(
        '/api/photos/search',
        queryParameters: {"search_text": searchTextController.text},
      ).then((value) => extractedData = value.data);
      setState(() {
        final photosSearchExtractedPosts =
            extractedData['results']['everyone_photos'] as List<dynamic>;
        print(photosSearchExtractedPosts);
        photosSearchResult.clear();
        photosSearchResult =
            postsPointer.setPostsFromMainserver(photosSearchExtractedPosts, 2);
        print(photosSearchResult.length);
      });
    } on DioError catch (error) {
      print(error.response.statusCode);
    }
  }

  ///
  Future<void> getPeopleSearchResultMainServer(Posts postsPointer) async {
    Dio dio = new Dio(
      BaseOptions(
        baseUrl: 'https://' + globals.HttpSingleton().getBaseUrl(),
      ),
    );
    dio.options.headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + globals.accessToken,
    };
    var extractedData;

    try {
      await dio.get(
        '/api/accounts/search',
        queryParameters: {'username': searchTextController.text},
      ).then((value) => extractedData = value.data);
      setState(() {
        peopleSearchResult.clear();

        /// clear old list.
        ///Extract the profiles of people that I follow.
        final followedPeopleSearchExtractedProfiles =
            extractedData['results']['following'] as List<dynamic>;
        print(followedPeopleSearchExtractedProfiles.length);

        ///Loop on each item in the list of people I follow to add the profile to the peopleSearchResult so they are displayed.
        followedPeopleSearchExtractedProfiles.forEach((followedPerson) {
          String profileId = followedPerson['followed']['id'].toString();
          String name = followedPerson['followed']['first_name'] +
              ' ' +
              followedPerson['followed']['last_name'];
          String profilePicUrl = followedPerson['followed']['profile_pic'] ==
                  null
              ? followedPerson['followed']['profile_pic']
              : 'https://fotone.me' + followedPerson['followed']['profile_pic'];
          String profileCoverPhoto = followedPerson['followed']
                      ['cover_photo'] ==
                  null
              ? followedPerson['followed']['cover_photo']
              : 'https://fotone.me' + followedPerson['followed']['cover_photo'];
          final followedPersonDetails = PicPosterDetails(
            profileId,
            name,
            followedPerson['followed']['is_pro'],
            followedPerson['followed']['is_followed'],
            profilePicUrl,
            profileCoverPhoto,
          );
          peopleSearchResult.add(followedPersonDetails);
        });
        final allPeopleSearchExtractedProfiles =
            extractedData['results']['all_people'] as List<dynamic>;
        print(allPeopleSearchExtractedProfiles.length);

        ///Loop on each item in the list of people to add the profile to the peopleSearchResult so they are displayed.
        allPeopleSearchExtractedProfiles.forEach((person) {
          String profileId = person['id'].toString();
          String name = person['first_name'] + ' ' + person['last_name'];
          String profilePicUrl = person['profile_pic'] == null
              ? person['profile_pic']
              : 'https://fotone.me' + person['profile_pic'];
          String profileCoverPhoto = person['cover_photo'] == null
              ? person['cover_photo']
              : 'https://fotone.me' + person['cover_photo'];
          final personDetails = PicPosterDetails(
            profileId,
            name,
            person['is_pro'],
            person['is_followed'],
            profilePicUrl,
            profileCoverPhoto,
          );
          peopleSearchResult.add(personDetails);
        });
        print(peopleSearchResult.length);
      });
    } on DioError catch (error) {
      print(error.response.statusCode);
    }
  }

  void searchResultMockService(List<PostDetails> postsToDisplay,
      List<PicPosterDetails> loadedPicPosterProfiles) {
    setState(
      () {
        if (searchTextController.text.length > 0) {
          ///Searches for the word(s) in the tags section of the posts.
          photosSearchResult = [
            ...postsToDisplay.where(
              (post) => post.tags.contains(
                searchTextController.text,
              ),
            )
          ];

          /// Searches for the word(s) in the name of the users.
          peopleSearchResult = loadedPicPosterProfiles
              .where(
                (profile) => profile.name.contains(
                  searchTextController.text,
                ),
              )
              .toList();
        } else {
          photosSearchResult = [];
          peopleSearchResult = [];
        }
      },
    );
  }

  /// When the user searches for anything this function is called and it applies the search criteria on the available data to extract the data the user needs.
  Future<void> submitData(
      List<PostDetails> postsToDisplay,
      List<PicPosterDetails> loadedPicPosterProfiles,
      Posts postsPointer) async {
    if (globals.isMockService) {
      searchResultMockService(postsToDisplay, loadedPicPosterProfiles);
    } else {
      await getPhotosSearchResultMainServer(postsPointer);
      await getPeopleSearchResultMainServer(postsPointer);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Gets all the posts available.
    final postsToDisplay = Provider.of<Posts>(context).posts;
    final postsPointer = Provider.of<Posts>(context);

    ///Gets the profiles of available users to search among them.
    final loadedPicPosterProfiles =
        Provider.of<Posts>(context).picPosterProfilesDetails;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: Icon(Icons.search),
          automaticallyImplyLeading: false,
          title: TextField(
            controller: searchTextController,
            onSubmitted: (_) => submitData(
                postsToDisplay, loadedPicPosterProfiles, postsPointer),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search Flickr",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            FlatButton(
              //padding: EdgeInsets.all(5),
              height: 10,
              //autofocus: true,
              shape: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            //isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: 'Photos',
              ),
              Tab(
                text: 'People',
              ),
              Tab(
                text: 'Groups',
              ),
            ],
          ),
        ),
        body: TabBarView(
          /// User can navigate between these tabs to see the result of his/her search.
          children: <Widget>[
            SearchPhotos(photosSearchResult),
            SearchPeople(peopleSearchResult),
            SearchGroups(),
          ],
        ),
      ),
    );
  }
}
