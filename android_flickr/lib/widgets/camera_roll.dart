import 'package:android_flickr/screens/PhotoGalleryScreen.dart';
import 'package:flutter/material.dart';

class CameraRoll extends StatefulWidget {
  @override
  _CameraRollState createState() => _CameraRollState();
}

class _CameraRollState extends State<CameraRoll> {
  bool hasImages = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: Column(
        children: [
          hasImages
              ? Container()
              : Column(
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
                            builder: (BuildContext context) =>
                                PhotoGalleryScreen(),
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
        ],
      ),
    );
  }
}
