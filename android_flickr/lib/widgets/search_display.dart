import 'package:android_flickr/screens/search_screen.dart';
import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';

/// SearchDisplay is displayed when the search tab is pressed and it shows random photos and search textfield which when pressed navigates to search screen.
class SearchDisplay extends StatefulWidget {
  @override
  SearchDisplayState createState() => SearchDisplayState();
}

class SearchDisplayState extends State<SearchDisplay> {
  ScrollController _controller = ScrollController();

  /// To know whether to hide the grid/list view options or know based on user scrolling.
  bool closeTopContainer = false;
  void clickOnImageScreen(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> allPosts, int exploreindex) {
    /// Navigator is used here when we click on the image.

    /// postInformation is passed as an argument so ClickOnImageScreen can know which details it will display.
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: {
        'postDetails': allPosts,
        'isFromPersonalProfile': false,
        'explorePosts': allPosts,
        'postIndex': exploreindex,
        'ExORPup': 'explore'
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        /// If user swiped up for certain amount the container of the grid/list view options is hidden.
        closeTopContainer = _controller.offset > 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
    return Column(
      children: [
        /// Navigates to the search screen when pressed.
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          child: AnimatedContainer(
            color: Colors.grey,
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: closeTopContainer
                ? 0
                : MediaQuery.of(context).size.height * 0.06,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.search),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Search Flickr",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          /// Displays the random images.
          child: ListView.builder(
            controller: _controller,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  clickOnImageScreen(
                      context, postsToDisplay[index], postsToDisplay, index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    postsToDisplay[index].postImageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
            itemCount: postsToDisplay.length,
          ),
        ),
      ],
    );
  }
}
