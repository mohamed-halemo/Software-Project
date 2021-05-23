import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search-screen';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: Icon(Icons.search),
          automaticallyImplyLeading: false,
          title: TextField(
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
          //widgets each tab will display
          children: <Widget>[
            //wrapped with refresh indicator which runs the _refreshExplore function when triggered
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
