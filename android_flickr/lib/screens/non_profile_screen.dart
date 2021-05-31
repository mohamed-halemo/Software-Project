import 'package:android_flickr/providers/flickr_profiles.dart';
import 'package:android_flickr/widgets/tabbar_in_non_profile.dart';
import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import 'package:provider/provider.dart';

/// Screen that displays the other users profile with tabbar to navigate between diffrent details in this profile.
class NonProfileScreen extends StatelessWidget {
/*   void getProfileDetails(String profileid) {
    FlickrProfiles().profiles.where((profile) => profile.profileID == profileid);
  } */

  static const routeName = '/non-profile-screen';
  @override
  Widget build(BuildContext context) {
    final detailsOfProfile = ModalRoute.of(context).settings.arguments as List;

    /// instance of Post details that contains info about the profile that we are viewing.
    final postInformation = detailsOfProfile[0] as PostDetails;
    final profileData = detailsOfProfile[1] as FlickrProfile;
    //print(profileData.profilePosts.length);

    return ChangeNotifierProvider(
      create: (context) => profileData,
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
                            postInformation.postImageUrl,
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
