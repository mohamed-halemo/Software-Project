//out of the box imports
import 'package:flutter/material.dart';

//packages and plugins
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
  var photoscale = 0.0;

  /// explore or puplic
  String isExOrPuplic = '';

  ///Bool used to determine data intitialization completion
  bool isFirstLoad = true;

  ///Swiper controller for swiping images
  SwiperController mySwipeController = new SwiperController();

  ///Function that navigates to non personal profile screen of the profile pressed, takes the build context
  /// and the information of the current post
  void goToNonprofile(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> currentPosts, FlickrProfiles flickrProfiles) {
    final flickrProfileDetails = flickrProfiles.addProfileDetailsToList(
        postInformation.picPoster, currentPosts);
    /* final flickrProfileDetails = FlickrProfiles().profiles.where(
        (profile) => profile.profileID == postInformation.picPoster.profileId); */
    // print(flickrProfileDetails.profileID);
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: [postInformation, flickrProfileDetails],
    );
  }

  /// true if this screen was opened from camera roll, false otherwise
  bool isFromPersonalProfile;
  bool isFromNonProfile;

  /// instance of Post details that contains info about the post we are currently displaying
  var postInformation;

  ///List of all Posts
  List<PostDetails> allPosts = [];

  ///Index of current post
  var postIndex;

  ///Data and state variables initializer
  void firstLoad(Map settingsMap) {
    isFromPersonalProfile = settingsMap['isFromPersonalProfile'];
    isFromNonProfile = settingsMap['isFromNonProfile'];
    // if (isFromPersonalProfile) {
    allPosts = settingsMap['postDetails'];
    postIndex = settingsMap['postIndex'];
    postInformation = allPosts[postIndex];
    // } else {
    //   isExOrPuplic = settingsMap['ExORPup'];
    //   postInformation = settingsMap['postDetails'];
    // }
    isFirstLoad = false;
  }

  ///called with every rebuild, updates post information with new index
  void reload(Map settingsMap) {
    // if (isFromPersonalProfile) {
    postInformation = allPosts[postIndex];
    // } else {
    // postInformation = settingsMap['postDetails'];
    // ;
    // }
  }

  ///Main Build method. Rebuilds with state update.
  @override
  Widget build(BuildContext context) {
    ///Modal route settings from calling screen
    final settingsMap =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    isFirstLoad ? firstLoad(settingsMap) : reload(settingsMap);

    ///All posts available at the moment.
    final currentPosts = Provider.of<Posts>(context).posts;

    ///All profiles available at the moment.
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
          child: Swiper(
            loop: false,
            itemCount: allPosts.length,
            index: postIndex,
            controller: mySwipeController,
            // onTap: (_) {
            //   // isDetailsOfPostDisplayed = false;
            // },
            onIndexChanged: (value) async {
              // print(value);
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
              child: Stack(
                //fit: StackFit.expand,
                children: [
                  Center(
                    //display image of the post
                    child: ClipRRect(
                      child: PhotoView(
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: 8.0,
                        controller: photoViewController,
                        initialScale: photoscale,
                        imageProvider:
                            NetworkImage(allPosts[index].postImageUrl),
                      ),
                    ),
                  ),
                  Align(alignment: Alignment.center),

                  /// So when we tap on the screen the bottom bar and top bar navigate between disappear and appear.
                  if (isDetailsOfPostDisplayed)
                    ClickOnImageDisplayPostDetails(
                      postInformation: allPosts[index],
                      isFromPersonalProfile:
                          settingsMap['isFromPersonalProfile'],
                    ),
                  if (isDetailsOfPostDisplayed)
                    //display listtile which includes profile pic as circular avatar and name of the pic owner as title and cancel button to return to explore screen
                    ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          goToNonprofile(context, allPosts[index], currentPosts,
                              flickrProfiles);
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 20,
                          backgroundImage: allPosts[index]
                                      .picPoster
                                      .profilePicUrl !=
                                  null
                              ? NetworkImage(
                                  allPosts[index].picPoster.profilePicUrl,
                                )
                              : AssetImage(
                                  'assets/images/FlickrDefaultProfilePic.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          goToNonprofile(context, allPosts[index], currentPosts,
                              flickrProfiles);
                        },
                        child: Text(
                          allPosts[index].picPoster.name,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///When the User presses the Edit button (if the photo is owned by this user), Displays a
  /// dialog that asks the user to wait till download is finished. Once finished, Downloaded image's
  ///  path is pushed to the photo edit screen.

}
