import 'package:android_flickr/widgets/search_groups.dart';
import 'package:android_flickr/widgets/search_people.dart';
import 'package:android_flickr/widgets/search_photos.dart';
import 'package:flutter/material.dart';

/// When the search textfield is pressed in the search tab on explore screen, this screen is displayed with textfield for the user to search for group/photo/people.
class SearchScreen extends StatelessWidget {
  final searchTextController = TextEditingController();
  static const routeName = '/search-screen';

  void submitData() {
    print("nice");
  }

  @override
  Widget build(BuildContext context) {
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
            onSubmitted: (_) => submitData(),
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
            SearchPhotos(),
            SearchPeople(),
            SearchGroups(),
          ],
        ),
      ),
    );
  }
}
