import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/widgets/pic_postedBy_info_on_post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

///Tests the trailing part returns the write text.
void main() {
  final postInformation = PostDetails(
    id: "1",
    dateTaken: DateTime.now(),
    privacy: false,
    description: "",
    tags: [],
    picPoster: PicPosterDetails("1", "moaz", true, false, 20, 0, 0, "", ""),
    commentsTotalNumber: 20,
    postImageUrl: "postImageUrl",
    postedSince: "6w",
    favesDetails: FavedPostDetails(favedUsersNames: [], isFaved: true),
  );
  final picPostedByInfoOnPostInstance =
      PicPostedByInfoOnPost(postInformation, true);
  test("Display posted since when", () {
    //Arrange
    //BuildContext context;
    postInformation.picPoster.isFollowedByUser = true;
    postInformation.picPoster.followedDuringRunning = true;

    SizedBox postedSinceWidget =
        picPostedByInfoOnPostInstance.widgetToBeDisplayedAsTrailing(20);
    Text textWidget = postedSinceWidget.child;
    String matcher = textWidget.data;

    //Act

    String actual = "6w";

    //Assert

    expect(actual, matcher);
  });

  group("caption available", () {
    test("Followed by user and not followed during running", () {
      //Arrange
      //BuildContext context;
      postInformation.picPoster.isFollowedByUser = true;
      postInformation.picPoster.followedDuringRunning = false;
      picPostedByInfoOnPostInstance.inPublicMode = false;
      postInformation.caption = "A great day";

      Text textWidget =
          picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
      String matcher = textWidget.data;

      //Act
      String actual = "A great day";
      //Assert

      expect(actual, matcher);
    });

    test("In public mode", () {
      //Arrange
      //BuildContext context;
      postInformation.picPoster.isFollowedByUser = true;
      postInformation.picPoster.followedDuringRunning = true;
      picPostedByInfoOnPostInstance.inPublicMode = true;
      postInformation.caption = "A great day";

      Text textWidget =
          picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
      String matcher = textWidget.data;

      //Act
      String actual = "A great day";
      //Assert

      expect(actual, matcher);
    });
  });
  group("caption unavailable", () {
    test("Followed by user and not followed during running", () {
      //Arrange
      //BuildContext context;
      postInformation.picPoster.isFollowedByUser = true;
      postInformation.picPoster.followedDuringRunning = false;
      picPostedByInfoOnPostInstance.inPublicMode = false;
      postInformation.caption = "";

      Text textWidget =
          picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
      String matcher = textWidget.data;

      //Act
      String actual = "";
      //Assert

      expect(actual, matcher);
    });

    test("In public mode", () {
      //Arrange
      //BuildContext context;
      postInformation.picPoster.isFollowedByUser = true;
      postInformation.picPoster.followedDuringRunning = true;
      picPostedByInfoOnPostInstance.inPublicMode = true;
      postInformation.caption = "";

      Text textWidget =
          picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
      String matcher = textWidget.data;

      //Act
      String actual = "";
      //Assert

      expect(actual, matcher);
    });
  });
  test("Followed during running from explore", () {
    //Arrange
    //BuildContext context;
    postInformation.picPoster.isFollowedByUser = true;
    postInformation.picPoster.followedDuringRunning = true;
    picPostedByInfoOnPostInstance.inPublicMode = false;
    postInformation.caption = "";

    Text textWidget =
        picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
    String matcher = textWidget.data;

    //Act
    String actual = "Following recomended";
    //Assert

    expect(actual, matcher);
  });
  test("Recommended on explore", () {
    //Arrange
    //BuildContext context;
    postInformation.picPoster.isFollowedByUser = false;
    postInformation.picPoster.followedDuringRunning = false;
    picPostedByInfoOnPostInstance.inPublicMode = false;
    postInformation.caption = "";

    Text textWidget =
        picPostedByInfoOnPostInstance.widgetToBeDisplayedAsSubtitle();
    String matcher = textWidget.data;

    //Act
    String actual = "Recomended";
    //Assert

    expect(actual, matcher);
  });
}
