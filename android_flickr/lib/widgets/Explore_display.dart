//import 'dart:io';
//import 'dart:math';
import 'package:android_flickr/widgets/explore_post.dart';

//import '../providers/flickr_post.dart';
import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Explore describes how the posts on explore page are build and displayed.
class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final inPublicMode = false;
  final isProfile = false;

  /// The widget returns ListView.builder that controls how the post will be displayed to the user.

  @override
  Widget build(BuildContext context) {
    ///
    /// Setup a listener from class posts to notify me with any updates in the list of posts.
    final postsToDisplay = Provider.of<Posts>(context).posts;

    return ListView.builder(
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        /// We provide it with ChangeNotifierProvider so it creates a seperate provider for each Post.
        return ChangeNotifierProvider.value(
          value: postsToDisplay[index],

          /// False in explore post is to indicate that posts are displayed in explore mode
          /// not public mode to display the popupmenu button accordingly.
          child: ExplorePost(inPublicMode, index, isProfile),
        );
      },
    );
  }
}
