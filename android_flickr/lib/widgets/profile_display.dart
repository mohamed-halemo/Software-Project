import 'package:android_flickr/Classes/globals.dart';
import 'package:android_flickr/screens/get_started_page_screen.dart';
import 'package:flutter/material.dart';
import './tabbar_in_profile.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_profiles.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/flickr_posts.dart';

/// Profile of the user which includes their avatar, followers and following and a tabbar.
class ProfileDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profilePicAndCover =
        Provider.of<MyProfile>(context).getProfilePicCoverPhoto;

    return NestedScrollView(
      headerSliverBuilder: (context, index) {
        return [
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () {},
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: GestureDetector(
                        child: Text("Sign out"),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('email');
                          prefs.setBool('remember', false);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) =>
                                      GetStartedScreen()));
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: Text("bad"),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Image.network(
                    profilePicAndCover['profilePic'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.43,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      profilePicAndCover['profileCoverPhoto'],
                    ),
                  ),
                ),
              ],
            ),
            expandedHeight: 200,
          ),
        ];
      },

      /// Tabbar (public,camera roll,groups...) that is nested in the main tabbar.
      body: TabbarInProfile(),
    );
  }
}
