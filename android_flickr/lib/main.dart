import 'package:android_flickr/screens/GetStartedPage_screen.dart';
import 'package:android_flickr/screens/flickr_Camera_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './colors/blackSwatch.dart' as primBlack;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      title: 'Flickr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        primarySwatch: primBlack.primaryBlack,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlickrCameraScreen(),
    );
  }
}
