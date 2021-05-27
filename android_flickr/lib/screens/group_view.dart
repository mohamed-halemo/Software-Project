import 'package:android_flickr/widgets/public_view_grid.dart';
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
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
            PublicViewGrid(),
            Center(),
          ],
        ),
      ),
    );
  }
}
