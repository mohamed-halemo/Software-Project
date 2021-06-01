//out of the box imports
import 'package:flutter/material.dart';

//packages and plugins
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//personal imports
import '../providers/flickr_posts.dart';
import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/screens/PhotoGalleryScreen.dart';
import 'package:android_flickr/screens/click_on_image_screen.dart';
// import '../Classes/globals.dart' as globals;

///Camera Roll page where the user can view his images, open and edit them,
///set privacy and delete.
class CameraRoll extends StatefulWidget {
  @override
  CameraRollState createState() => CameraRollState();
}

///Camera Roll state class, contains the main widget tree of camera roll,
///as well as all it's state variables
class CameraRollState extends State<CameraRoll> {
  ///Bool used to determine if the user library has Posts or not.
  bool hasImages = false;

  ///List of all user Posts.
  List<PostDetails> postsToDisplay;

  ///fetch user images at initState
  @override
  void initState() {
    super.initState();

    // var mockUrl =
    //     // Uri.https('mockservice-zaka-default-rtdb.firebaseio.com', 'Photo.json');
    //     Uri.http(globals.HttpSingleton().getBaseUrl(),
    //         globals.isMockService ? '/Photo' : '/api/Photo');
  }

  ///Main widget tree, rebuilds with every state update.
  @override
  Widget build(BuildContext context) {
    //get posts from provider
    postsToDisplay = Provider.of<Posts>(context).myPosts;
    if (postsToDisplay.isEmpty) {
      setState(() {
        hasImages = false;
      });
    } else {
      setState(() {
        hasImages = true;
      });
    }
    return hasImages
        ? gridBuilder()
        : Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.image_outlined,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Upload your photos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Text(
                    'Have you got a lot of photos? We\'ve got a lot of space.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.black,
                    ),
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PhotoGalleryScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Upload now',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  ///Returns A String of the photo's Date Posted and bellow that a grid of images,
  /// that were posted that day and has a max of
  /// four images per row.
  Widget gridBuilder() {
    return ListView.builder(
      itemBuilder: (context, listindex) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  DateFormat('EEEE _ MMM d, yyyy')
                      .format(postsToDisplay.first.dateTaken),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                //TODO dynamic count
                itemCount: 6,
                itemBuilder: (context, gridindex) {
                  return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ClickOnImageScreen.routeName,
                            arguments: {
                              'postDetails': postsToDisplay,
                              'postIndex': gridindex,
                              'isFromPersonalProfile': true
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            Image.network(
                                postsToDisplay[gridindex].postImageUrl),
                            postsToDisplay[gridindex].privacy
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 15,
                                        )),
                                  ),
                          ],
                        ),
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ));
                }),
          ],
        );
      },
      //TODO dynamic count
      itemCount: 10,
    );
  }
}
