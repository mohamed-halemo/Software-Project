//import 'package:android_flickr/widgets/explore_post.dart';

//import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/flickr_posts.dart';

/// Gridview that displays only the images of the user(currently using the device) posts in grid mode.
// ignore: must_be_immutable
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
    return postsToDisplay.length > 0
        ? StaggeredGridView.countBuilder(
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
            /* gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ), */
          )
        : Center(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width / 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 5.5,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey,
                          size: 50,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Share your pics!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Take a photo or make photos public from the Camera roll",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
