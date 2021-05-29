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

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore-screen';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var currentIndex = 0;
  Future<void> _refreshExplore(BuildContext context) async {
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
    //this is the Main screen where we have diffrent tabs one of them is only configured which is the explore display
    return /* DefaultTabController(
      initialIndex: currentIndex,
      length: 5,
      child:  */
        Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: NestedScrollView(
        //to scroll through posts and also scroll the tab bar
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
          //widgets each tab will display
          children: <Widget>[
            //wrapped with refresh indicator which runs the _refreshExplore function when triggered
            RefreshIndicator(
              onRefresh: () {
                return _refreshExplore(context);
              },
              child: Explore(), //display the explore posts
            ),

            SearchDisplay(),
            ProfileDisplay(),
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
                    //DefaultTabController.of(context).index = 2;
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
