import 'package:android_flickr/screens/add_tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

//This Test Follows the Arrange Act Assert pattern for tasting
//Arrange: prepare the matcher and do any initializations
//Act: Proceed with the method Call and get the Actual value
//Assert: Expect Actual to be equal to matcher, if yes test pass
void main() {
  //used for mocking app context
  MockBuildContext _myMockContext;
  //an instance of the add tags screen widget
  AddTagsScreen _addTagsScreen;
  //Tag management Testing, tests for adding and deleting tags
  group('Tag management', () {
    test('add one tag', () {
      //Arrange
      List<String> matcher = ['unitTest'];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded = _addTagsScreen.addTag(_myMockContext, 'unitTest');
      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded, true);
    });

    test('add multiple tags', () {
      //Arrange
      List<String> matcher = ['1', '2', '3'];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, '1');
      bool isTagAdded2 = _addTagsScreen.addTag(_myMockContext, '2');
      bool isTagAdded3 = _addTagsScreen.addTag(_myMockContext, '3');
      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, true);
      expect(isTagAdded2, true);
      expect(isTagAdded3, true);
    });
    test('add empty tag', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, '');
      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, false);
    });
    test('add invalid tag: a', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, 'a');

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, false);
    });
    test('add invalid tag: A', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, 'A');

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, false);
    });
    test('add invalid tag: i', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, 'i');

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, false);
    });
    test('add invalid tag: I', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = [];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      bool isTagAdded1 = _addTagsScreen.addTag(_myMockContext, 'I');

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
      expect(isTagAdded1, false);
    });

    test('delete first Tag', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = ['firstTag'];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      _addTagsScreen.deleteTag(0);

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
    });
    test('delete multiple Tags', () {
      //Arrange
      List<String> matcher = [];
      List<String> tags = ['firstTag', 'secondTag', 'thirdTag'];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      _addTagsScreen.deleteTag(2);
      _addTagsScreen.deleteTag(1);
      _addTagsScreen.deleteTag(0);

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
    });
    test('delete Tag with invalid index', () {
      //Arrange
      List<String> matcher = ['firstTag'];
      List<String> tags = ['firstTag'];
      _addTagsScreen = AddTagsScreen(tags);
      _myMockContext = MockBuildContext();

      //Act
      _addTagsScreen.deleteTag(10);

      List<String> actual = _addTagsScreen.tags;
      //Assert
      expect(actual, matcher);
    });
  });
}
