//import 'dart:async';
import 'package:splashscreen/splashscreen.dart';
//import './get_started_page_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';

/// A class responsible for displaying the loading screen with the flickr gif when app is loading posts from the server.
class FlickrSplashScreen extends StatefulWidget {
  static const routeName = '/flick-splash-screen';

  /// takes a widget that it should display after it finishes loading data from server.
  final Widget screenDisplayedAfterSplash;

  FlickrSplashScreen(this.screenDisplayedAfterSplash);
  @override
  _FlickrSplashScreenState createState() => _FlickrSplashScreenState();
}

class _FlickrSplashScreenState extends State<FlickrSplashScreen> {
  //var _init = true;

  /* @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<Posts>(context).fetchAndSetExplorePosts();  
    }
    _init = false;
    super.didChangeDependencies();
  } */
  /* @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushNamed(
        GetStartedScreen.routeName,
      );
    });
  } */

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      //seconds: 3,

      /// Use navigateAfterFuture where we fetch data from database and then loads the screen widget we passed in the constructor.
      navigateAfterFuture: Provider.of<Posts>(context)
          .fetchAndSetExplorePosts()
          .then((_) => widget.screenDisplayedAfterSplash),
      backgroundColor: Colors.grey.withOpacity(0.1),
      loaderColor: Colors.transparent,
      image: Image.asset(
        'assets/images/flickr_loading_screen.gif',
      ),
      photoSize: 75,
      //navigateAfterSeconds: widget.screenDisplayedAfterSplash,
    );
  }
}
