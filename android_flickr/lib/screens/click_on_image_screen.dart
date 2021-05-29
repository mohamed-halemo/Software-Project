import 'package:flutter/material.dart';
import '../providers/flickr_post.dart';
//import 'package:provider/provider.dart';
import '../widgets/click_on_image_post_details.dart';
import '../screens/non_profile_screen.dart';

/// Whenever any post image is clicked, the app navigates to this screen in order to display the image and few other details.
class ClickOnImageScreen extends StatefulWidget {
  static const routeName = '/click-on-image-screen';
  @override
  _ClickOnImageScreenState createState() => _ClickOnImageScreenState();
}

class _ClickOnImageScreenState extends State<ClickOnImageScreen> {
  bool isDetailsOfPostDisplayed = true;

  void _goToNonprofile(BuildContext ctx, PostDetails postInformation) {
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: postInformation,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Instance of Post details that contains info about the post we are currently displaying.
    final postInformation =
        ModalRoute.of(context).settings.arguments as PostDetails;

    //final postInformation = Provider.of<PostDetails>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          //fit: StackFit.expand,
          children: [
            /// So when we tap on the screen the bottom bar and top bar navigate between disappear and appear.
            if (isDetailsOfPostDisplayed)
              ClickOnImageDisplayPostDetails(postInformation: postInformation),
            if (isDetailsOfPostDisplayed)

              /// Display listtile which includes profile pic as leading and name of the pic owner as title
              /// and cancel button to return to previous screen.
              ListTile(
                leading: GestureDetector(
                  onTap: () {
                    _goToNonprofile(context, postInformation);
                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 20,
                    backgroundImage: NetworkImage(
                      postInformation.picPoster.profilePicUrl,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    _goToNonprofile(context, postInformation);
                  },
                  child: Text(
                    postInformation.picPoster.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    isDetailsOfPostDisplayed = !isDetailsOfPostDisplayed;
                  },
                );
              },
              child: Center(
                /// Display image of the post.
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 4,
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      postInformation.postImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
