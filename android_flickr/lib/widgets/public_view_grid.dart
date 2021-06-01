//import 'package:android_flickr/widgets/explore_post.dart';

//import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/flickr_posts.dart';

/// Gridview that displays only the images of the user(currently using the device) posts in grid mode.
class PublicViewGrid extends StatelessWidget {
  bool isNonProfile;
  PublicViewGrid(this.isNonProfile);

  void clickOnImageScreen(
      BuildContext ctx, List<PostDetails> postInformation, int gridindex) {
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: {
        'postDetails': postInformation,
        'postIndex': gridindex,
        'isFromPersonalProfile': isNonProfile ? false : true,
        'ExORPup': 'puplic',
        'allPosts': postInformation,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).myPosts;
    //final postsToDisplay = Provider.of<Posts>(context).posts;
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      padding: EdgeInsets.all(7),
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            clickOnImageScreen(context, postsToDisplay, index);
          },
          child: Image.network(
            postsToDisplay[index].postImageUrl,
            fit: BoxFit.fill,
          ),
        );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      
    );
  }
}
