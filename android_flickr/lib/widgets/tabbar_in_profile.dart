import 'package:android_flickr/screens/your_groups_screen.dart';
import 'package:android_flickr/widgets/camera_roll.dart';
import 'package:android_flickr/widgets/profile_public.dart';
import 'package:flutter/material.dart';

/// Tabbar that is nested in user profiles screen(public,album,groups...) to implement the nested tabbars.
class TabbarInProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          toolbarHeight: MediaQuery.of(context).size.height / 14.2,
          //bottomOpacity: ,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: true,
            //dragStartBehavior: DragStartBehavior.,

            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            //isScrollable: true,
            tabs: [
              Tab(
                child: Text(
                  "About",
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
              Tab(
                child: Text(
                  "Stats",
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
              Tab(
                text: "Camera roll",
              ),
              Tab(
                text: "Public",
              ),
              Tab(
                child: Text(
                  "Albums",
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
              Tab(
                text: "Groups",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text("no About"),
            ),
            Center(
              child: Text("no Stats"),
            ),
            CameraRoll(),
            ProfilePublic(),
            Center(
              child: Text("no Albums"),
            ),
            Groups(),
          ],
        ),
      ),
    );
  }
}
