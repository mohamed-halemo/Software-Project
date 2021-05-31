import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/widgets/click_on_image_post_details.dart';
import 'package:flutter/cupertino.dart';
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
    favesDetails: FavedPostDetails(
        favedUsersNames: [], isFaved: true, favesTotalNumber: 2),
  );
  final clickOnImageDisplayPostDetailsInstance = ClickOnImageDisplayPostDetails(
    postInformation: postInformation,
  ).createState();

  group(("FavesText"), () {
    test("favesTotalNumber == 0 but commentsTotalNumber!=0", () {
      postInformation.favesDetails.favesTotalNumber = 0;
      postInformation.commentsTotalNumber = 3;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.favesText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "0 faves";
      //Assert
      expect(actual, matcher);
    });
    test("favesTotalNumber != 0", () {
      postInformation.favesDetails.favesTotalNumber = 5;
      postInformation.commentsTotalNumber = 5;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.favesText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "5 faves";
      //Assert
      expect(actual, matcher);
    });
    test("favesTotalNumber == 1", () {
      postInformation.favesDetails.favesTotalNumber = 1;
      postInformation.commentsTotalNumber = 1;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.favesText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "1 fave";
      //Assert
      expect(actual, matcher);
    });
  });
  group(("CommentsText"), () {
    test("commentsTotalNumber == 0 but favesTotalNumber!=0", () {
      postInformation.favesDetails.favesTotalNumber = 1;
      postInformation.commentsTotalNumber = 0;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.commentsText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "0 comments";
      //Assert
      expect(actual, matcher);
    });
    test("commentsTotalNumber != 0", () {
      postInformation.favesDetails.favesTotalNumber = 5;
      postInformation.commentsTotalNumber = 5;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.commentsText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "5 comments";
      //Assert
      expect(actual, matcher);
    });
    test("commentsTotalNumber == 1", () {
      postInformation.favesDetails.favesTotalNumber = 1;
      postInformation.commentsTotalNumber = 1;
      //postInformation.favesDetails.favesTotalNumber = 1;
      //Arrange
      Text textWidget =
          clickOnImageDisplayPostDetailsInstance.commentsText(postInformation);
      String matcher = textWidget.data;
      //Act
      String actual = "1 comment";
      //Assert
      expect(actual, matcher);
    });
  });
}
