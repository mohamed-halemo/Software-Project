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
//import 'package:provider/provider.dart';
import '../widgets/click_on_image_post_details.dart';
import '../screens/non_profile_screen.dart';
import '../providers/flickr_profiles.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';
import 'image_info_screen.dart';
import 'package:android_flickr/screens/photoEditScreen.dart';

/// Whenever any post image is clicked, the app navigates to this screen in order to display the image and few other details.
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
  void _goToNonprofile(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> currentPosts, FlickrProfiles flickrProfiles) {
    final flickrProfileDetails = flickrProfiles.addProfileDetailsToList(
        postInformation.picPoster, currentPosts);
    /* final flickrProfileDetails = FlickrProfiles().profiles.where(
        (profile) => profile.profileID == postInformation.picPoster.profileId); */
    print(flickrProfileDetails.profileID);
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: [postInformation, flickrProfileDetails],
    );
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
    final currentPosts = Provider.of<Posts>(context).posts;
    final flickrProfiles = Provider.of<FlickrProfiles>(context);
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
            /// So when we tap on the screen the bottom bar and top bar navigate between disappear and appear.
            if (isDetailsOfPostDisplayed)
              ClickOnImageDisplayPostDetails(postInformation: postInformation),
              if (isDetailsOfPostDisplayed)
                //display listtile which includes profile pic as circular avatar and name of the pic owner as title and cancel button to return to explore screen
                ListTile(
                leading: GestureDetector(
                  onTap: () {
                    _goToNonprofile(context, postInformation, currentPosts,flickrProfiles);
                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 20,
                    backgroundImage: NetworkImage(
                      postInformation.picPoster.profilePicUrl,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    _goToNonprofile(context, postInformation, currentPosts,flickrProfiles);
                  },
                  child: Text(
                    postInformation.picPoster.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
