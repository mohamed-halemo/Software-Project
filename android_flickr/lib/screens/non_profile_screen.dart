import 'package:android_flickr/widgets/tabbar_in_non_profile.dart';
import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';

/// Screen that displays the other users profile with tabbar to navigate between diffrent details in this profile.
class NonProfileScreen extends StatelessWidget {
  static const routeName = '/non-profile-screen';
  @override
  Widget build(BuildContext context) {
    /// instance of Post details that contains info about the profile that we are viewing.
    final postInformation =
        ModalRoute.of(context).settings.arguments as PostDetails;
    return Scaffold(
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
            body: TabbarInNonProfile(),
          ),
        ),
      ),
    );
  }
}
