import 'package:android_flickr/widgets/explore_post.dart';

import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Public View displays the posts like the explore mode but the diffrence is there is posted since when instead of popup menu in the posts of unfollowed user.
class PublicViewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
    return ListView.builder(
      //controller: _controller,
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: postsToDisplay[index],

          /// True in explore post is to indicate that posts are displayed in public mode not explore mode.
          child: ExplorePost(true),
        );
      },
    );
  }
}
