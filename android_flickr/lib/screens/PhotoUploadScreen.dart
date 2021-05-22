//out of the box imports

import 'package:android_flickr/screens/add_tags_screen.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data' as typedData;
import 'dart:io';

import 'dart:convert';

//Packages and Plugins
import 'package:bitmap/bitmap.dart' as btm;
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../Classes/globals.dart' as globals;

//Photo upload screen where user adds image info before uploading it to the server
class PhotoUploadScreen extends StatefulWidget {
  /// The headedBitmap from the Photo edit screen is passed to this widget through the constructor
  final typedData.Uint8List headedBitmap;
  final btm.Bitmap editedBitmap;
  PhotoUploadScreen(this.headedBitmap, this.editedBitmap);
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  List<String> tags = [];
  String privacy = 'Public';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

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
      body: Padding(
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
                    builder: (BuildContext context) => AddTagsScreen(tags),
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
                    getTagsText(),
                  ],
                ),
                tags.isEmpty
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
    );
  }

  Widget getTagsText() {
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

  void postAndSaveImage() async {
    String path;
    await getTemporaryDirectory().then(
      (value) => path = value.path,
    );
    String fullPath = path;
    fullPath = path + DateTime.now().day.toString() + '.jpg';
    String imageName = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString() +
        '_' +
        DateTime.now().hour.toString() +
        '-' +
        DateTime.now().minute.toString() +
        '-' +
        DateTime.now().second.toString();
    final _imageSaver = ImageSaver();
    final res = await _imageSaver.saveImage(
      imageBytes: widget.editedBitmap.buildHeaded(),
      directoryName: "Flickr",
      imageName: imageName + '.jpg',
    );
    print(res);
    print(imageName);

    var mockUrl =
        // Uri.https('mockservice-zaka-default-rtdb.firebaseio.com', 'Photo.json');
        Uri.http(globals.HttpSingleton().getBaseUrl(), 'Photo');

    var toBeEncodedMap = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_public': privacy == 'Public' ? true : false,
    };
    var jsonBody = json.encode(toBeEncodedMap);
    print('Post Request: ' + jsonBody);
    await http.post(
      mockUrl,
      body: jsonBody,
      headers: {"Content-Type": "application/json"},
    );
  }
}
