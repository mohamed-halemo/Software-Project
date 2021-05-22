import 'package:android_flickr/providers/flickr_post.dart';
import 'package:android_flickr/screens/PhotoGalleryScreen.dart';
import 'package:android_flickr/screens/click_on_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../Classes/globals.dart';
import '../providers/flickr_posts.dart';
import 'package:provider/provider.dart';

class CameraRoll extends StatefulWidget {
  @override
  _CameraRollState createState() => _CameraRollState();
}

class _CameraRollState extends State<CameraRoll> {
  bool hasImages = false;

  // ///List of all Albums that hold [Image] assets
  // Album flickrAlbum;

  // ///List of Merged Albums, holding both Images and Videos
  // List<Album> gallery = [];

  // List<Medium> photos = [];

  // List<DateTime> dateTimeList = [];
  // List<DateTime> listOfDays = [];

  List<PostDetails> postsToDisplay;

  @override
  Widget build(BuildContext context) {
    postsToDisplay = Provider.of<Posts>(context).posts;
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
                itemCount: 6,
                itemBuilder: (context, gridindex) {
                  return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ClickOnImageScreen.routeName,
                            arguments: {
                              'postDetails': postsToDisplay[gridindex],
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
      itemCount: 10,
    );
  }
}
