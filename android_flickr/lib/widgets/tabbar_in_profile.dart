import 'package:android_flickr/widgets/camera_roll.dart';
import 'package:android_flickr/widgets/profile_public.dart';
import 'package:flutter/material.dart';

class TabbarInProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          //titleSpacing: 50,
          /* title: Text(
            "moaz",
            style: TextStyle(color: Colors.black),
          ), */
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
                text: "About",
              ),
              Tab(
                text: "Stats",
              ),
              Tab(
                text: "Camera roll",
              ),
              Tab(
                text: "Public",
              ),
              Tab(
                text: "Albums",
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
            Center(
              child: Text("no Groups"),
            ),
          ],
        ),
      ),
    );
  }
}
