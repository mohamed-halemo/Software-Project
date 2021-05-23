import 'package:android_flickr/screens/search_screen.dart';
import '../providers/flickr_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/click_on_image_screen.dart';
import '../providers/flickr_post.dart';

class SearchDisplay extends StatefulWidget {
  @override
  _SearchDisplayState createState() => _SearchDisplayState();
}

class _SearchDisplayState extends State<SearchDisplay> {
  ScrollController _controller = ScrollController();
  bool closeTopContainer = false;
  void clickOnImageScreen(BuildContext ctx, PostDetails postInformation) {
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: postInformation,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        closeTopContainer = _controller.offset > 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsToDisplay = Provider.of<Posts>(context).posts;
    return Column(
      children: [
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
          child: ListView.builder(
            controller: _controller,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  clickOnImageScreen(context, postsToDisplay[index]);
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
