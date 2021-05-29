//out of the box imports
import 'dart:io';
import 'package:flutter/material.dart';

//packages and plugins
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' show get;
import 'package:photo_view/photo_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Personal imports
import '../providers/flickr_post.dart';
import 'image_info_screen.dart';
import 'package:android_flickr/screens/photoEditScreen.dart';

///this class is responsible for all the features and widgets that will be displayed when we click on the post image in Explore display
class ClickOnImageScreen extends StatefulWidget {
  ///Route name used for Navigation
  static const routeName = '/click-on-image-screen';
  @override
  ClickOnImageScreenState createState() => ClickOnImageScreenState();
}

///ClickOnImageScreen State Object
class ClickOnImageScreenState extends State<ClickOnImageScreen> {
  ///true if the post details is displayed, false if hidden. Hide post details by tapping on image
  ///, tap again to show again.
  bool isDetailsOfPostDisplayed = true;

  ///Controller for PhotoView Plugin
  var photoViewController = PhotoViewController();

  ///Scale of the Zoom of the photo.
  var photoscale = 1.0;

  bool isFirstLoad = true;

  SwiperController mySwipeController = new SwiperController();

  ///returns a widget which tells me the which string in Text widget that will be displayed based on the favesTotalNumber
  Widget favesText(PostDetails postInformation) {
    if ((postInformation.favesDetails.favesTotalNumber > 1 ||
            postInformation.commentsTotalNumber != 0) &&
        postInformation.favesDetails.favesTotalNumber != 1) {
      return Text(
        '${postInformation.favesDetails.favesTotalNumber}' + ' faves',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else if (postInformation.favesDetails.favesTotalNumber == 1) {
      return Text(
        '${postInformation.favesDetails.favesTotalNumber}' + ' fave',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5.25,
      );
    }
  }

  ///returns a widget which tells me the which string in Text widget that will be displayed based on the commentsTotalNumber
  Widget commentsText(PostDetails postInformation) {
    if ((postInformation.commentsTotalNumber > 1 ||
            postInformation.favesDetails.favesTotalNumber != 0) &&
        postInformation.commentsTotalNumber != 1) {
      return Text(
        '${postInformation.commentsTotalNumber}' + ' comments',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else if (postInformation.commentsTotalNumber == 1) {
      return Text(
        '${postInformation.commentsTotalNumber}' + ' comment',
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5.25,
      );
    }
  }

  bool isFromPersonalProfile;
  var postInformation;
  var allPosts;
  var postIndex;

  void firstLoad(Map settingsMap) {
    isFromPersonalProfile = settingsMap['isFromPersonalProfile'];
    allPosts = settingsMap['postDetails'];
    postIndex = settingsMap['postIndex'];
    if (settingsMap['isFromPersonalProfile']) {
      postInformation = allPosts[postIndex];
    } else {
      postInformation = allPosts;
    }
    isFirstLoad = false;
  }

  void reload() {
    postInformation = allPosts[postIndex];
  }

  ///Main Build method. Rebuilds with state update.
  @override
  Widget build(BuildContext context) {
    final settingsMap =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    /// instance of Post details that contains info about the post we are currently displaying

    isFirstLoad ? firstLoad(settingsMap) : reload();
    //final postInformation = Provider.of<PostDetails>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () {
          setState(
            () {
              photoscale = photoViewController.scale;
              isDetailsOfPostDisplayed = !isDetailsOfPostDisplayed;
            },
          );
        },
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            //fit: StackFit.expand,
            children: [
              if (isDetailsOfPostDisplayed)
                //display listtile which includes profile pic as circular avatar and name of the pic owner as title and cancel button to return to explore screen
                ListTile(
                  leading: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 20,
                    backgroundImage: NetworkImage(postInformation.postImageUrl),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(
                    postInformation.picPoster.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel_outlined),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              Center(
                //display image of the post
                child: Swiper(
                  itemCount: settingsMap['isFromPersonalProfile']
                      ? allPosts.length
                      : 1,
                  index: postIndex,
                  controller: mySwipeController,
                  onIndexChanged: (value) async {
                    // setState(() {
                    //   if (settingsMap['isFromPersonalProfile'])
                    //     postInformation = allPosts[value];
                    // });
                    // mySwipeController.next();

                    print(value);
                    // await mySwipeController.move(value + 1, animation: true);

                    if (settingsMap['isFromPersonalProfile']) {
                      if (allPosts.length > value) {
                        postIndex = value;
                        setState(() {});
                      }
                    }
                  },
                  itemBuilder: (BuildContext context, int index) => Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).size.height / 4,
                    ),
                    child: ClipRRect(
                      child: PhotoView(
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: 8.0,
                        controller: photoViewController,
                        initialScale: photoscale,
                        imageProvider: NetworkImage(
                          settingsMap['isFromPersonalProfile']
                              ? allPosts[index].postImageUrl
                              : postInformation.postImageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isDetailsOfPostDisplayed) //so when we tap on the screen the bottom bar and top bar navigate between disappear and appear
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                    ),
                    if (postInformation.caption != null)
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 17),
                          Text(postInformation.caption,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    if (postInformation.caption == null)
                      Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        isFromPersonalProfile
                            ? IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  downloadImage(postInformation);
                                },
                              )
                            :
                            //displays bottom bar which includes fave 0, comment button, share button, info button and faves and comments total number
                            IconButton(
                                icon: postInformation.favesDetails.isFaved
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  setState(
                                    () {
                                      postInformation.toggleFavoriteStatus();
                                    },
                                  );
                                },
                              ),
                        IconButton(
                          icon: Icon(
                            Icons.comment_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageInfoScreen(postInformation),
                              ),
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            favesText(postInformation),
                            commentsText(postInformation),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  ///When the User presses the Edit button (if the photo is owned by this user), Displays a
  /// dialog that asks the user to wait till download is finished. Once finished, Downloaded image's
  ///  path is pushed to the photo edit screen.
  void downloadImage(PostDetails postInformation) async {
    var _alertDownload = AlertDialog(
      content: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Downloading',
          style: TextStyle(
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (_) => _alertDownload,
      barrierDismissible: false,
    );
    Uri uri = Uri.parse(postInformation.postImageUrl);
    var response = await get(uri);
    var tempDir = await getTemporaryDirectory();
    var firstPath = tempDir.path + "/images";
    var filePathAndName = tempDir.path + '/images/pic.jpg';
    await Directory(firstPath).create(recursive: true).then(
      (value) {
        File file = new File(filePathAndName);
        file.writeAsBytesSync(response.bodyBytes);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PhotoEditScreen(filePathAndName),
          ),
        );
      },
    );
  }
}
