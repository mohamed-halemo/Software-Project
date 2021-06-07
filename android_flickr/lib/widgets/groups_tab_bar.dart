import 'package:android_flickr/screens/new_discussion.dart';
import 'package:android_flickr/widgets/groups_photo_view.dart';
import 'package:flutter/material.dart';
import 'package:android_flickr/widgets/public_view_grid.dart';
import 'package:path/path.dart';

/// The Appbar of the groups view
class GroupsTabBar extends StatefulWidget {
  ///Group id number
  final int id;
  GroupsTabBar(this.id);
  @override
  _GroupsTabBarState createState() => _GroupsTabBarState();
}

class _GroupsTabBarState extends State<GroupsTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height / 14.2,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: "Photos",
              ),
              Tab(
                text: "Discussions",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupsPhotoView(widget.id),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10)),
                  Center(
                    ///Button that when clicked moves you to the new discussion page
                    child: OutlineButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewDiscussion()));
                      },
                      child: Text(
                        'New Discussion',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                    ),
                    //heightFactor: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
