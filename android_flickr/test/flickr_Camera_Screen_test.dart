import 'package:android_flickr/Enums/enums.dart';
import 'package:android_flickr/Classes/switch_Case_Helper.dart';
import 'package:flutter_test/flutter_test.dart';

//This Test Follows the Arrange Act Assert pattern for tasting
//Arrange: prepare the matcher and do any initializations
//Act: Proceed with the method Call and get the Actual value
//Assert: Expect Actual to be equal to matcher, if yes test pass
void main() {
  //Camera FlashMode Testing, On flash mode change,
  //the path to the flash mode image updates
  group('FlashMode', () {
    test('FlashModeAlways', () {
      //Arrange
      String matcher = 'assets/images/FlashAlways.png';
      //Act
      String actual = SwitchCaseHelper.getFlashMode(UserFlashMode.always);
      //Assert
      expect(actual, matcher);
    });
    test('FlashModeAuto', () {
      //Arrange
      String matcher = 'assets/images/FlashAuto.png';
      //Act
      String actual = SwitchCaseHelper.getFlashMode(UserFlashMode.auto);
      //Assert
      expect(actual, matcher);
    });
    test('FlashModeNever', () {
      //Arrange
      String matcher = 'assets/images/FlashNever.png';
      //Act
      String actual = SwitchCaseHelper.getFlashMode(UserFlashMode.never);
      //Assert
      expect(actual, matcher);
    });
  });
}
