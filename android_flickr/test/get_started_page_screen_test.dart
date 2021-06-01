//import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/screens/get_started_page_screen.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final getStartedScreenInstance = GetStartedScreen().createState();

  group("ScreenTitle", () {
    test("index = 0", () {
      //Arrange
      //BuildContext context;
      String matcher = getStartedScreenInstance.setStartedScreenTitle(0);

      //Act

      String actual = 'Powerful';

      //Assert

      expect(actual, matcher);
    });
    test("index = 1", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenTitle(1);

      //Act

      String actual = 'Keep your memories safe';

      //Assert

      expect(actual, matcher);
    });
    test("index = 2", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenTitle(2);

      //Act

      String actual = 'Organisation simpified';

      //Assert

      expect(actual, matcher);
    });
    test("index = 3", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenTitle(3);

      //Act

      String actual = 'Sharing made easy';

      //Assert

      expect(actual, matcher);
    });
  });
  group("ScreenSubTitle", () {
    test("index = 0", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenSubTitle(0);

      //Act

      String actual = 'Save all of your photos and videos in one place.';

      //Assert

      expect(actual, matcher);
    });
    test("index = 1", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenSubTitle(1);

      //Act

      String actual =
          'Your uploaded photos stay private until you choose to share them.';

      //Assert

      expect(actual, matcher);
    });
    test("index = 2", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenSubTitle(2);

      //Act

      String actual = 'Search, edit and organise in seconds.';

      //Assert

      expect(actual, matcher);
    });
    test("index = 3", () {
      //Arrange
      //BuildContext context;

      String matcher = getStartedScreenInstance.setStartedScreenSubTitle(3);

      //Act

      String actual = 'Share with friends, family and the world.';

      //Assert

      expect(actual, matcher);
    });
  });
}
