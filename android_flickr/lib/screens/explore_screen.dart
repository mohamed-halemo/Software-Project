import 'package:android_flickr/screens/flickr_Camera_Screen.dart';
//import 'package:android_flickr/screens/search_screen.dart';
import 'package:android_flickr/widgets/profile_display.dart';
import 'package:android_flickr/widgets/search_display.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/explore_display.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';
import 'package:swipedetector/swipedetector.dart';

/// This is the Main screen where we have diffrent tabs(explore, search,personal profile, notifications, camera).
class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore-screen';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  /// The index of the selected tab which is used to navigate from the notification view to the profile view.
  ///
  /// This is because the notification is wrapped in a swipedetector which overrides the swipe functionality of the TABBAR.
  var currentIndex = 0;

  Future<void> _refreshExplore(BuildContext context) async {
    /// Uses the function fetchAndSetExplorePosts to reload the latest posts from the mock service.
    await Provider.of<Posts>(context, listen: false).fetchAndSetExplorePosts();
  }

  void _goToFlickrCamera(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      FlickrCameraScreen.routeName,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /* DefaultTabController(
      initialIndex: currentIndex,
      length: 5,
      child:  */
        Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            SliverAppBar(
              elevation: 0,
              toolbarHeight: 0,
              floating: true,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey.shade900,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,

                //isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.image,
                    ),
                    //text: 'Categories',
                  ),
                  Tab(
                    icon: GestureDetector(
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                    //text: 'Favorites',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.account_circle,
                      //color: Colors.white,
                    ),
                    //text: 'Categories',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    //text: 'Favorites',
                  ),
                  GestureDetector(
                    /// To navigate to the flickr camera screen and not the tabbar view
                    onTap: () {
                      _goToFlickrCamera(context);
                    },
                    child: Tab(
                      icon: Icon(
                        Icons.camera_alt,
                      ),
                      //text: 'Categories',
                    ),
                  ),
                ],
              ),
            )
          ];
        },
        dragStartBehavior: DragStartBehavior.start,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            /// List of the widgets to navigate among.

            RefreshIndicator(
              onRefresh: () {
                return _refreshExplore(context);
              },
              child: Explore(),
            ),
            SearchDisplay(),
            ProfileDisplay(),

            /// Helps to go to the camera screen instead of the tabbar view.
            SwipeDetector(
              onSwipeLeft: () {
                setState(() {
                  _goToFlickrCamera(context);
                });
              },
              onSwipeRight: () {
                setState(
                  () {
                    currentIndex = 0;
                    _tabController.index = 2;
                  },
                );
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Text(
                  "no notifications",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: Text("no camera"),
            ),
          ],
        ),
      ),
      //),
    );
  }
}
