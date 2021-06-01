import 'package:android_flickr/widgets/search_groups.dart';
import 'package:android_flickr/widgets/search_people.dart';
import 'package:android_flickr/widgets/search_photos.dart';
import '../providers/flickr_posts.dart';
import '../providers/flickr_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  /// When the user searches for anything this function is called and it applies the search criteria on the available data to extract the data the user needs.
  void submitData(List<PostDetails> postsToDisplay,
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

  @override
  Widget build(BuildContext context) {
    ///Gets all the posts available.
    final postsToDisplay = Provider.of<Posts>(context).posts;

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
            onSubmitted: (_) =>
                submitData(postsToDisplay, loadedPicPosterProfiles),
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
