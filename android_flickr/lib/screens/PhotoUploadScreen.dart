//out of the box imports

import 'package:android_flickr/screens/add_tags_screen.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data' as typedData;
import 'dart:io';

//Packages and Plugins
import 'package:bitmap/bitmap.dart' as btm;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

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
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Title...',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
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
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.label_outlined,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Tags'),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_open_sharp,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Public'),
              ],
            ),
          ],
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
    img.Image imageToBeSaved =
        img.decodeBmp(widget.editedBitmap.buildHeaded().toList());
    await File(fullPath).writeAsBytes(img.encodeJpg(imageToBeSaved));

    if (fullPath != null) {
      final result = await ImageGallerySaver.saveFile(fullPath);
      print(result);
    } else {
      print('Null path');
    }
  }
}
