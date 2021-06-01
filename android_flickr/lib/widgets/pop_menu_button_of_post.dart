import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import '../providers/flickr_posts.dart';
import 'package:provider/provider.dart';

/// Popup menu that is used to follow the recommended users in the explore.
class PopupMenuButtonOfPost extends StatelessWidget {
  ///
  /// Instance of post details that contains info about the post to set the info about faves and comments.
  final PostDetails postInformation;

  PopupMenuButtonOfPost(this.postInformation);
  @override
  Widget build(BuildContext context) {
    final allPosts = Provider.of<Posts>(context).posts;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 20,
      child: PopupMenuButton(
        /// Popupmenubutton takes on selected as an argument where we add the function followPicPoster to follow the owner of the post when option is pressed.

        onSelected: (int option) {
          if (option == 0) {
            postInformation.followPicPoster(allPosts);
          }
          if (option == 1) {
            //GestureDetector().onTap();
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }
        },
        itemBuilder: (ctx) {
          return [
            PopupMenuItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Text(
                    'follow ' + postInformation.picPoster.name,
                    style: TextStyle(),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
              value: 0,
            ),
            PopupMenuItem(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    Text(
                      'Why am I seeing this?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Text(
                      'This is a recomendation hand-picked from our community.',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                  ],
                ),
              ),
              value: 1,
            ),
          ];
        },
        icon: Icon(Icons.more_vert),
      ),
    );
  }
}
