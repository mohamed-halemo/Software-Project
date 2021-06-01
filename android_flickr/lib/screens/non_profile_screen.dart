import 'package:android_flickr/providers/flickr_profiles.dart';
import 'package:android_flickr/widgets/tabbar_in_non_profile.dart';
import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import '../providers/flickr_posts.dart';
import 'package:provider/provider.dart';

/// Screen that displays the other users profile with tabbar to navigate between diffrent details in this profile.
class NonProfileScreen extends StatefulWidget {
/*   void getProfileDetails(String profileid) {
    FlickrProfiles().profiles.where((profile) => profile.profileID == profileid);
  } */

  static const routeName = '/non-profile-screen';

  @override
  _NonProfileScreenState createState() => _NonProfileScreenState();
}

class _NonProfileScreenState extends State<NonProfileScreen> {
  ///Recieves the profile details and list of all posts to update the ones he posted when the follow button is pressed.
  void toggleFollowPicPoster(
      PicPosterDetails personDetails, List<PostDetails> currentPosts) {
    //print("first");
    //print(personDetails.isFollowedByUser);
    final profileFirstPostFound = currentPosts.firstWhere(
        (post) => post.picPoster.profileId == personDetails.profileId);
    profileFirstPostFound.toggleFollowPicPoster(currentPosts, personDetails);
    //print("second");
    //print(personDetails.isFollowedByUser);
  }

  @override
  Widget build(BuildContext context) {
    final detailsOfProfile = ModalRoute.of(context).settings.arguments as List;

    /// instance of Post details that contains info about the profile that we are viewing.
    final postInformation = detailsOfProfile[0] as PostDetails;
    final profileData = detailsOfProfile[1] as FlickrProfile;
    //print(profileData.profilePosts.length);

    final currentPosts = Provider.of<Posts>(context).posts;

    return MultiProvider(
      providers: [
        ///Helps in public to know which posts is the users posts.
        ChangeNotifierProvider(
          create: (context) => profileData,
        ),
        ///To update listeners if the followed button was pressed.
        ChangeNotifierProvider(
          create: (ctx) => postInformation,
        ),
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 4,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (context, index) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: true,
                    flexibleSpace: Stack(
                      children: [
                        FlexibleSpaceBar(
                          background: Image.network(
                            postInformation.picPoster.profileCoverPhoto,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.2,
                          left: MediaQuery.of(context).size.width * 0.4,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              postInformation.picPoster.profilePicUrl,
                            ),
                          ),
                        ),
                      ],
                    ),
                    expandedHeight: 200,
                    actions: [
                      /// Follow button.
                      FlatButton(
                        shape: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        color: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            toggleFollowPicPoster(
                                postInformation.picPoster, currentPosts);
                          });
                        },
                        child: postInformation.picPoster.isFollowedByUser
                            ? Icon(
                                Icons.beenhere_outlined,
                                color: Colors.white,
                              )
                            : Text(
                                "+" + " Follow",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ];
              },

              /// Allows the user to view public, groups,... about the currently viewed profile.
              body: TabbarInNonProfile(profileData),
            ),
          ),
        ),
      ),
    );
  }
}
