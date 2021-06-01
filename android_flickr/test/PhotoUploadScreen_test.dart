import 'dart:typed_data';

import 'package:android_flickr/screens/PhotoUploadScreen.dart';
import 'package:bitmap/bitmap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

//This Test Follows the Arrange Act Assert pattern for tasting
//Arrange: prepare the matcher and do any initializations
//Act: Proceed with the method Call and get the Actual value
//Assert: Expect Actual to be equal to matcher, if yes test pass
void main() {
  MockBuildContext _myMockContext;

  PhotoUploadScreen _photoUploadScreen;
  //Tag management, tests empty tags
  //Non empty tags require app context and widget testing
  group('Photo Upload Tests', () {
    test('empty Tags Widget', () {
      //Arrange
      String matcher = 'Tags';
      _myMockContext = MockBuildContext();
      Uint8List a;
      Bitmap b;
      _photoUploadScreen = PhotoUploadScreen(a, b);
      //Act
      Text textWidget = _photoUploadScreen.getTagsText(_myMockContext);
      String actual = textWidget.data;
      //Assert
      expect(actual, matcher);
    });
  });
}
