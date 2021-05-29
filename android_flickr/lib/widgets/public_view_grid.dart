//import 'package:android_flickr/widgets/explore_post.dart';

import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';

class PublicViewGrid extends StatelessWidget {
  var postsToDisplay;

  void clickOnImageScreen(
      BuildContext ctx, PostDetails postInformation, int gridindex) {
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: {
        'postDetails': postsToDisplay,
        'postIndex': gridindex,
        'isFromPersonalProfile': true,
        'isFromPublic': true
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    postsToDisplay = Provider.of<Posts>(context).posts;
    return GridView.builder(
      padding: EdgeInsets.all(7),
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            clickOnImageScreen(context, postsToDisplay[index], index);
          },
          child: Image.network(
            postsToDisplay[index].postImageUrl,
            fit: BoxFit.fill,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
