import 'package:flutter_test/flutter_test.dart';
import '../lib/Classes/globals_moaz.dart' as globals;

//This Test Follows the Arrange Act Assert pattern for tasting
//Arrange: prepare the matcher and do any initializations
//Act: Proceed with the method Call and get the Actual value
//Assert: Expect Actual to be equal to matcher, if yes test pass
void main() {
  //HttpSingleton Testing, if isMockService flag is true, returns mock url
  //if false, returns real server url
  group('HttpSingleton', () {
    // test('Baseurl_Mock_true', () {
    //   //Arrange
    //   bool original = globals.isMockService;
    //   globals.isMockService = true;
    //   String matcher = '192.168.1.10:3000';
    //   //Act
    //   String actual = globals.HttpSingleton().getBaseUrl();
    //   //Assert
    //   expect(actual, matcher);
    //   globals.isMockService = original;
    // });
    test('Baseurl_Mock_false', () {
      //Arrange
      bool original = globals.isMockService;
      globals.isMockService = false;
      String matcher = 'https://fotone.me/api';
      //Act
      String actual = globals.HttpSingleton().getBaseUrl();
      //Assert
      expect(actual, matcher);
      globals.isMockService = original;
    });
  });
}
