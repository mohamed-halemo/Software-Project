import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/widgets/few_details_of_faves_comments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final postInformation = PostDetails(
      id: "1",
      dateTaken: DateTime.now(),
      privacy: false,
      description: "",
      tags: "",
      picPoster: PicPosterDetails("1","moaz", true, false, ""),
      commentsTotalNumber: 20,
      postImageUrl: "postImageUrl",
      postedSince: "6w",
      favesDetails: FavedPostDetails(favedUsersNames: [], isFaved: true));
  final fewDetailsOfFavesCommentsInstance =
      FewDetailsOfFavesComments(postInformation);
  group("Faved details,", () {
    group("One faved,", () {
      test("Not you", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 3;
        postInformation.favesDetails.favedUsersNames = ["moaz"];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "moaz faved";
        //Assert

        expect(actual, matcher);
      });
      test("You faved", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 3;
        postInformation.favesDetails.favedUsersNames = ["You"];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "You faved";
        //Assert

        expect(actual, matcher);
      });
    });
    group("Two faved,", () {
      test("Not you", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 2;
        postInformation.favesDetails.favedUsersNames = ["Ahmed", "mohamed"];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "Ahmed and mohamed faved";
        //Assert

        expect(actual, matcher);
      });
      test("You included", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 2;
        postInformation.favesDetails.favedUsersNames = [
          "You",
          "Ahmed",
        ];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "You and Ahmed faved";
        //Assert

        expect(actual, matcher);
      });
    });
    group("More than three faved", () {
      test(" but not you", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 20;
        postInformation.favesDetails.favedUsersNames = ["Ahmed", "mohamed"];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "Ahmed, mohamed and 18 others faved";
        //Assert

        expect(actual, matcher);
      });
      test("You included", () {
        //Arrange
        postInformation.favesDetails.favesTotalNumber = 20;
        postInformation.favesDetails.favedUsersNames = [
          "You",
          "Ahmed",
          "mohamed"
        ];
        String matcher = fewDetailsOfFavesCommentsInstance.favesNames;
        //Act

        String actual = "You, Ahmed and 18 others faved";
        //Assert

        expect(actual, matcher);
      });
    });
  });
}
