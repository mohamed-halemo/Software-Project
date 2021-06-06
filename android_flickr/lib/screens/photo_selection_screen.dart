//out of the box imports
import 'dart:io';
import 'package:flutter/material.dart';

//packages and plugins
import 'package:photo_gallery/photo_gallery.dart';

//personal imports
import 'package:android_flickr/screens/photo_edit_screen.dart';

///A Screen where the user can tap on an image to pick it for upload
class PhotoSelectionScreen extends StatefulWidget {
  ///The Album That the user picked in the Gallery Screen. The Album media is displayed in this screen
  ///and the user should choose an image to upload.
  final Album _album;

  ///Constructor, takes an album.
  PhotoSelectionScreen(this._album);
  @override
  PhotoSelectionScreenState createState() => PhotoSelectionScreenState();
}

///Photo Selection Screen State Object
class PhotoSelectionScreenState extends State<PhotoSelectionScreen> {
  /// used to display number of images selected (Can Only Select One Image).
  int selected = 0;

  ///A List of Files holding image thumbnails to display.
  List<File> thumbnailData = [];

  ///Initialize Thumbnail List with thumbnails recieved from albums.
  Future initAlbum() async {
    await widget._album
        .listMedia(
      newest: true,
      skip: 0,
    )
        .then((value) async {
      for (var i = widget._album.count - 1; i > -1; i--) {
        await value.items[i].getFile().then((value) {
          setState(() {
            thumbnailData.add(value);
          });
        });
      }
    });
  }

  ///Overrides default initState method by initializing album and Filling thumbnail data
  ///, once done, then setState and rebuild.
  @override
  void initState() {
    super.initState();
    initAlbum().then((value) {
      setState(() {});
    });
  }

  ///main build method, rebuilds with state update.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              child: ListTile(
                leading: Text(
                  widget._album.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$selected selected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 0.1,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: 18,
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: widget._album.count,
                  itemBuilder: (context, index) {
                    return Container(
                        child: GestureDetector(
                          onTap: () {
                            pushEditScreen(index);
                          },
                          child: getThumbnails(index),
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }

  ///For the thumbnail of the passed index, Create an image widget of type File and use
  ///thumbnail file.
  Widget getThumbnails(int index) {
    try {
      return Image.file(
        thumbnailData[index],
        fit: BoxFit.cover,
      );
    } catch (e) {}
    return Container();
  }

  ///For the Image of the passed index, Get the image file, get the image path, and pass it
  ///to the PhotoEditScreen and oush it to start editing the image.
  void pushEditScreen(int index) async {
    String imagePath;
    await widget._album.listMedia().then(
      (value) {
        value.items[value.items.length - index - 1].getFile().then((value) {
          imagePath = value.path;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  PhotoEditScreen(imagePath, false, 0),
            ),
          );
        });
      },
    );
  }
}
