import './few_details_of_faves_comments.dart';
import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
import 'package:provider/provider.dart';
import 'pic_postedBy_info_on_post.dart';
import '../screens/click_on_image_screen.dart';

/// Explore post describes how each post will be displayed and the widgets it will use.
class ExplorePost extends StatelessWidget {
  final inPublicMode;
  void clickOnImageScreen(BuildContext ctx, PostDetails postInformation) {
    /// Navigator is used here when we click on the image.

    /// postInformation is passed as an argument so ClickOnImageScreen can know which details it will display.
    Navigator.of(ctx).pushNamed(
      ClickOnImageScreen.routeName,
      arguments: postInformation,
    );
  }

  ExplorePost(this.inPublicMode);
  @override
  Widget build(BuildContext context) {
    /// We set up a listener here to class Posts to listen any change to the post.
    final postInformation = Provider.of<PostDetails>(context);
    return ChangeNotifierProvider(
      /// A container that click on image screen will listen to so it is notified with any change in post details like fave.
      create: (context) => postInformation,
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                clickOnImageScreen(context, postInformation);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 4,
                ),
                child: ClipRRect(
                  child: FadeInImage(
                    /// Takes the place ot the post image until the post image loads.
                    placeholder: AssetImage("assets/images/placeholder.png"),
                    image: NetworkImage(
                      postInformation.postImageUrl,
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            /// Widget that displays picPoster avatar, name, caption and since when was this post posted.
            PicPostedByInfoOnPost(postInformation,inPublicMode),

            /// Configurations and widgets choosen for the three buttons, fave , comments and share.
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Divider(
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: postInformation.favesDetails.isFaved
                            ? Icon(
                                Icons.star,
                                color: Colors.blue,
                              )
                            : Icon(
                                Icons.star_border_outlined,
                              ),
                        onPressed: () {
                          postInformation.toggleFavoriteStatus();
                        },
                      ),
                      if (postInformation.favesDetails.favesTotalNumber != 0)
                        Text(
                          postInformation.favesDetails.favesTotalNumber
                              .toString(),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.comment_outlined),
                          onPressed: () {},
                        ),
                        if (postInformation.commentsTotalNumber != 0)
                          Text(
                            postInformation.commentsTotalNumber.toString(),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      //Text("6"),
                    ],
                  ),
                ],
              ),
            ),

            /// Few details displayed about the comment(last comment) and one or two names if availabe of the users who faved the post.
            FewDetailsOfFavesComments(postInformation),
          ],
        ),
      ),
    );
  }
}
