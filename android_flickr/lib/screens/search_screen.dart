import 'package:android_flickr/widgets/search_groups.dart';
import 'package:android_flickr/widgets/search_people.dart';
import 'package:android_flickr/widgets/search_photos.dart';
import '../providers/flickr_posts.dart';
import '../providers/flickr_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// When the search textfield is pressed in the search tab on explore screen, this screen is displayed with textfield for the user to search for group/photo/people.
class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchTextController = TextEditingController();

  List<PostDetails> photosSearchResult = [];
  List<PostDetails> peopleSearchResult = [];

  void submitData(List<PostDetails> postsToDisplay) {
    setState(
      () {
        photosSearchResult = [
          ...postsToDisplay.where(
            (post) => post.tags.contains(
              searchTextController.text,
            ),
          )
        ];
        var duplicatePeopleResult = [
          ...postsToDisplay.where(
            (post) => post.picPoster.name.contains(
              searchTextController.text,
            ),
          )
        ];
        print(duplicatePeopleResult.length);
        List<String> ids = [];
        peopleSearchResult = duplicatePeopleResult.toSet().toList();
        print("a7a");
        /* duplicatePeopleResult.where(
          (post) {
            print(ids.contains(post.picPoster.profileId));
            if (!ids.contains(post.picPoster.profileId)) {
              print("adding");
              ids.add(post.picPoster.profileId);
              peopleSearchResult.add(post);
            }
            return peopleSearchResult.contains(post);
          },
        ); */
        /* print(peopleSearchResult.length);
        peopleSearchResult.removeWhere(
          (post) {
            //print(peopleSearchResult.length);
            final comparison = [
              ...peopleSearchResult.where((postToCompare) =>
                  postToCompare.picPoster.profileId == post.picPoster.profileId)
            ].length;
            print(comparison);
            return comparison > 1;
          },
        );
        print(peopleSearchResult.length); */
      },
    );
    //print(photosSearchResult.length);

    /* String trial = "Moaz";
    if (trial.contains("a")) {
      print("feeh a");
    } */
  }

  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
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
            onSubmitted: (_) => submitData(postsToDisplay),
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
