import 'package:android_flickr/widgets/explore_post.dart';

import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//class Explore describes how the posts on explore page are build and displayed
class PublicViewPost extends StatelessWidget {
  
  //The widget returns ListView builder to display the posts in listview mode and builder helps in improving the performance of the application
  //we provide it with ChangeNotifierProvider so it creates a provider for the class Post
  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
    return ListView.builder(
      //controller: _controller,
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: postsToDisplay[index],
          child: ExplorePost(true),
        );
      },
    );
  }
}
