import 'package:android_flickr/Enums/enums.dart';
import 'package:android_flickr/screens/photo_edit_screen.dart';
import 'package:flutter_test/flutter_test.dart';

//This Test Follows the Arrange Act Assert pattern for tasting
//Arrange: prepare the matcher and do any initializations
//Act: Proceed with the method Call and get the Actual value
//Assert: Expect Actual to be equal to matcher, if yes test pass
void main() {
  PhotoEditScreen photoEditScreen;
  //Brush mode management, tests Settint brush mode
  group('Brush Mode', () {
    test('Set Brush Mode: Saturation', () {
      //Arrange
      BrushMode matcher = BrushMode.Saturation;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(0);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
    test('Set Brush Mode: Exposure', () {
      //Arrange
      BrushMode matcher = BrushMode.Exposure;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(1);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
    test('Set Brush Mode: Contrast', () {
      //Arrange
      BrushMode matcher = BrushMode.Contrast;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(2);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
    test('Set Brush Mode: Brightness', () {
      //Arrange
      BrushMode matcher = BrushMode.Brightness;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(3);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
    test('Set Brush Mode: Rotate', () {
      //Arrange
      BrushMode matcher = BrushMode.Rotate;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(4);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
    test('Set Brush Mode: Invalid Input', () {
      //Arrange
      BrushMode matcher = BrushMode.Saturation;
      photoEditScreen = PhotoEditScreen('_');

      //Act
      photoEditScreen.setBrushState(77);
      BrushMode actual = photoEditScreen.brushMode;
      //Assert
      expect(actual, matcher);
    });
  });
}
