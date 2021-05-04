import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

enum SlideNumber {
  slide1,
  slide2,
  slide3,
  slide4,
}

class GetStartedScreen extends StatelessWidget {
  var screenState = SlideNumber.slide1;
  SlideNumber previousScreenState;
  String _title;
  String _subTitle;

  String get _SetStartedScreenImage {
    switch (screenState) {
      case SlideNumber.slide1:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide1.png';
        break;
      case SlideNumber.slide2:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide2.png';
        break;
      case SlideNumber.slide3:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide3.png';
        break;
      case SlideNumber.slide4:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide4.png';
        break;
      default:
        return 'Unknown';
    }
  }

  /* String get _PreviousSetStartedScreenImage {
    switch (previousScreenState) {
      case SlideNumber.slide1:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide1.png';
        break;
      case SlideNumber.slide2:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide2.png';
        break;
      case SlideNumber.slide3:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide3.png';
        break;
      case SlideNumber.slide4:
        return 'assets/images/GetStartedScreens/GetStartedScreenSlide4.png';
        break;
      default:
        return 'Unknown';
    }
  } */
  String _SetStartedScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'Powerful';
        break;
      case 1:
        return 'Keep your memories safe';
        break;
      case 2:
        return 'Organisation simpified';
        break;
      case 3:
        return 'Sharing made easy';
        break;
      default:
        return 'Unknown';
    }
  }

  String _SetStartedScreenSubTitle(int index) {
    switch (index) {
      case 0:
        return 'Save all of your photos and videos in one place.';
        break;
      case 1:
        return 'Your uploaded photos stay private until you choose to share them.';
        break;
      case 2:
        return 'Search, edit and organise in seconds.';
        break;
      case 3:
        return 'Share with friends, family and the world.';
        break;
      default:
        return 'Unknown';
    }
  }
  //void _SetStartedScreen() {

  @override
  Widget build(BuildContext context) {
/*     final appBar = AppBar(
      title: Text(""),
    ); */
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          //fit: StackFit.expand,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Swiper(
                containerWidth: double.infinity,
                //fade: 5,
                //autoplayDelay: 100,
                //autoplay: false,
                itemCount: 4,
                //curve: Curves.easeIn,
                //fade: 0.5,
                loop: false,
                //control: SwiperControl(),
                controller: SwiperController(),
                itemBuilder: (ctx, index) {
                  return Stack(
                    children: [
                      Image.asset(
                        'assets/images/GetStartedScreens/GetStartedScreenSlide' +
                            '${index + 1}' +
                            '.png',
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height / 1.75,
                          left: MediaQuery.of(context).size.width / 11,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 80,
                            alignment: Alignment.center,
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _SetStartedScreenTitle(index),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _SetStartedScreenSubTitle(index),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ))
                    ],
                  );
                },
                //viewportFraction: 1.5,
                scale: 1,
                pagination: SwiperPagination(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 5,
              left: MediaQuery.of(context).size.width / 3.5,
              child: Text(
                "flickr",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            /* Positioned(
                height: MediaQuery.of(context).size.height * 1.55,
                left: MediaQuery.of(context).size.width / 4,
                child: Container(
                  //width: 50,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.circle, size: 10),
                        onPressed: () {
                          setState(() {
                            previousScreenState = screenState;
                            screenState = SlideNumber.slide1;
                          });
                        },
                        color: Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.circle, size: 10),
                        onPressed: () {
                          setState(() {
                            previousScreenState = screenState;
                            screenState = SlideNumber.slide2;
                          });
                        },
                        color: Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.circle, size: 10),
                        onPressed: () {
                          setState(() {
                            previousScreenState = screenState;
                            screenState = SlideNumber.slide3;
                          });
                        },
                        color: Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.circle, size: 10),
                        onPressed: () {
                          setState(() {
                            previousScreenState = screenState;
                            screenState = SlideNumber.slide4;
                          });
                        },
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ), */
            Positioned(
              height: MediaQuery.of(context).size.height * 1.65,
              left: MediaQuery.of(context).size.width / 9,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 100,
                child: InkWell(
                  splashColor: Colors.blue,
                  child: FlatButton(
                    shape: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    height: 60,
/*                     hoverColor: Colors.blue,
                    focusColor: Colors.blue, */
                    minWidth: double.infinity,
                    onPressed: () {},
                    child: Text(
                      "Get started",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
                height: MediaQuery.of(context).size.height * 1.88,
                left: 10,
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Ben Flasher",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
