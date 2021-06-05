//out of the box imports

import 'package:flutter/material.dart';
import 'dart:typed_data' as typedData;
import 'dart:io';

//Packages and Plugins
import 'package:bitmap/bitmap.dart' as btm;
import 'package:path_provider/path_provider.dart';
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

//personal imports
import '../Classes/globals.dart' as globals;
import 'package:android_flickr/screens/add_tags_screen.dart';
import 'explore_screen.dart';

///Photo upload screen where user adds image info before uploading it to the server
// ignore: must_be_immutable
class PhotoUploadScreen extends StatefulWidget {
  /// The headedBitmap from the Photo edit screen is passed to this widget through the constructor
  /// it is a [Uint8List] and is used to render image on screen
  final typedData.Uint8List headedBitmap;

  ///The final bitmap of the image after all edits are done, if user chooses to post image
  ///, this bitmap is encoded to jpg format and is saved on device
  final btm.Bitmap editedBitmap;

  ///List of Tags added by the user
  List<String> tags = [];

  Widget getTagsText(BuildContext context) {
    if (tags.isEmpty) {
      return Text('Tags');
    }
    String text = '';
    for (var i = 0; i < tags.length; i++) {
      text.isEmpty ? text = tags[i] : text = text + ', ' + tags[i];
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  ///Constructor, takes a [Uint8List] and a [Bitmap]
  PhotoUploadScreen(this.headedBitmap, this.editedBitmap);
  @override
  PhotoUploadScreenState createState() => PhotoUploadScreenState();
}

///state object of Photo Upload Screen
class PhotoUploadScreenState extends State<PhotoUploadScreen> {
  ///Privacy of the image, if public, image is added to camera roll and public,
  /// if private, it is addes to only camera roll.
  String privacy = 'Public';

  ///Text Editing controller for title field
  final titleController = TextEditingController();

  ///Text Editing controller for description field
  final descriptionController = TextEditingController();

  ///Overrides the default dispose method to allow Landscape mode in edit View
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  ///Main build method. rebuilds with state update
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 56, 56),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    var snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.blue.shade500,
                      duration: Duration(days: 1),
                      content: Text(
                        'Uploading',
                        textAlign: TextAlign.center,
                      ),
                    );

                    try {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {}
                    postAndSaveImage();
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
              ),
              Container(
                height: 100,
                width: 100,
                child: Image.memory(
                  widget.headedBitmap,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                controller: titleController,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: 'Title...',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description...',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddTagsScreen(widget.tags),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Stack(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.label_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      widget.getTagsText(context),
                    ],
                  ),
                  widget.tags.isEmpty
                      ? Container()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  var alertDelete = AlertDialog(
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Edit privacy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                privacy = 'Public';
                              });
                              Navigator.pop(context);
                              return;
                            },
                            child: Text(
                              'Public',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Divider(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                privacy = 'Private';
                              });
                              Navigator.pop(context);
                              return;
                            },
                            child: Text(
                              'Private',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  showDialog(
                    context: context,
                    builder: (_) => alertDelete,
                    barrierDismissible: true,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      privacy == 'Public'
                          ? Icons.lock_open_sharp
                          : Icons.lock_outline_sharp,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(privacy),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO unit test this function
  ///Get default image title if no title was provided
  //////On Post button press, Generate file name in the format of:
  ///
  /// YYYY-MM-DD_hh-mm-ss
  ///
  String getDateTimetitle(DateTime dT) {
    return dT.year.toString() +
        '-' +
        dT.month.toString() +
        '-' +
        dT.day.toString() +
        '_' +
        dT.hour.toString() +
        '-' +
        dT.minute.toString() +
        '-' +
        dT.second.toString();
  }

  ///Then the image is saved on the local device in 'Flickr' folder, with jpg extension.
  /// After Saving to device, the image is uploaded to the server along with any
  /// available image info.
  void postAndSaveImage() async {
    globals.HttpSingleton().postAndSaveImage(
      context: context,
      descriptionController: descriptionController,
      editedBitmap: widget.editedBitmap,
      imageName: getDateTimetitle(DateTime.now()),
      privacy: privacy,
      tags: widget.tags,
      titleController: titleController,
    );
  }
}
