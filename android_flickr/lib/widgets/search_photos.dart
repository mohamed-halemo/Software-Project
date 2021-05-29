import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPhotos extends StatelessWidget {
  void clickOnImageScreen(BuildContext ctx, PostDetails postInformation) {
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: postInformation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      padding: EdgeInsets.all(7),
      itemCount: postsToDisplay.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            clickOnImageScreen(context, postsToDisplay[index]);
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
      /* gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ), */
    );
  }
}
