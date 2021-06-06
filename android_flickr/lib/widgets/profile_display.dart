import 'package:android_flickr/Classes/globals.dart';
import 'package:android_flickr/screens/get_started_page_screen.dart';
import 'package:android_flickr/screens/upadte_profile_photos_screen.dart';
import 'package:flutter/material.dart';
import './tabbar_in_profile.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_profiles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:charcode/charcode.dart' as charcode;

// import '../providers/flickr_posts.dart';

/// Profile of the user which includes their avatar, followers and following and a tabbar.
class ProfileDisplay extends StatefulWidget {
  @override
  _ProfileDisplayState createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  bool _init = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_init) {
      await Provider.of<MyProfile>(context).fetchMyProfileInfo();
      setState(() {
        _init = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myProfile = Provider.of<MyProfile>(context).myProfile;

    return myProfile == null
        ? Container(
            color: Colors.white,
          )
        : NestedScrollView(
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
                        background: myProfile.profileCoverPicUrl == null
                            ? Image.asset(
                                'assets/images/BlackCover.jpg',
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Image.network(
                                      myProfile.profileCoverPicUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.black.withOpacity(0.4),
                                  )
                                ],
                              ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: PopupMenuButton(
                            shape: Border.all(
                              width: double.infinity,
                            ),
                            offset: Offset(
                                MediaQuery.of(context).size.width * 0.30, 60),
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  break;
                                case 3:
                                  break;
                                case 4:
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              UploadProfilePicScreen(3),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                  break;
                                default:
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              myProfile.isPro
                                                  ? 'Pro'
                                                  : 'Join Pro',
                                              style: TextStyle(
                                                color: Colors.blue[800],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                80,
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              'Using ${myProfile.totalMedia} of 1000 photos',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                80,
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              'Edit profile photo',
                                              style: TextStyle(
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                80,
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                60,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              'Edit cover photo',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                80,
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: myProfile.profilePicUrl == null
                                  ? AssetImage(
                                      'assets/images/FlickrDefaultProfilePic.jpg')
                                  : NetworkImage(
                                      myProfile.profilePicUrl,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 35,
                          ),
                          child: Text(
                            myProfile.firstName + ' ' + myProfile.lastName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 85,
                          ),
                          child: Text(
                            '${myProfile.followersCount} followers' +
                                String.fromCharCode(0x2014) +
                                '${myProfile.followingCount} following',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: 150,
                ),
              ];
            },

            /// Tabbar (public,camera roll,groups...) that is nested in the main tabbar.
            body: TabbarInProfile(),
          );
  }
}
