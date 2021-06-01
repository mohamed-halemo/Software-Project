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
import 'package:splashscreen/splashscreen.dart';
import 'package:permission_handler/permission_handler.dart';

/// This is the Main screen where we have diffrent tabs(explore, search,personal profile, notifications, camera).
class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore-screen';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _controller = ScrollController();

  /// The index of the selected tab which is used to navigate from the notification view to the profile view.
  ///
  /// This is because the notification is wrapped in a swipedetector which overrides the swipe functionality of the TABBAR.
  var currentIndex = 0;

  /// Uses the function fetchAndSetExplorePosts to reload the latest posts from the mock service.
  Future<void> _refreshExplore(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetExplorePosts();
  }

  void _goToFlickrCamera(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      FlickrCameraScreen.routeName,
    );
  }

  void getPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();

    var status = await Permission.camera.status;
    if (status.isDenied) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    getPermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: NestedScrollView(
        controller: _controller,
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
            RefreshIndicator(
              onRefresh: () {
                return _refreshExplore(context);
              },
              child: Explore(),
            ),
            SearchDisplay(),
            ProfileDisplay(),

            Container(
              height: double.infinity,
              width: double.infinity,
              child: Text(
                "no notifications",
                style: TextStyle(color: Colors.white),
              ),
            ),
/*             SwipeDetector(
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
            ), */
            ///Go to the camera screen immediately when this tab is selected.
            SplashScreen(
              seconds: 0,
              navigateAfterSeconds: FlickrCameraScreen(),
              backgroundColor: Colors.grey.withOpacity(0.1),
              loaderColor: Colors.transparent,

              //navigateAfterSeconds: widget.screenDisplayedAfterSplash,
            ),
          ],
        ),
      ),
    );
  }
}
