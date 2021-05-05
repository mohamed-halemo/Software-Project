import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circle_list/circle_list.dart';
import 'package:bitmap/bitmap.dart';
import 'dart:math';

// import 'package:fab_circular_menu/fab_circular_menu.dart';
// import '../icons/my_flutter_app_icons.dart' as myIcons;

class PhotoEditScreen extends StatefulWidget {
  final imagePath;
  PhotoEditScreen(this.imagePath);
  @override
  _PhotoEditScreenState createState() => _PhotoEditScreenState();
}

class _PhotoEditScreenState extends State<PhotoEditScreen> {
  Bitmap imageBitMap;
  Uint8List headedBitMap;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    initImage();
  }

  initImage() async {
    imageBitMap = await Bitmap.fromProvider(AssetImage(widget.imagePath));
    headedBitMap = imageBitMap.buildHeaded();
    setState(() {});
  }

  // is the user editing with brush or filters?
  //if editing, whats edit mode? -1: Brush , 0: Not Editing , 1: Filters
  int editMode = 0;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 10,
          top: 10,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: headedBitMap == null
                  ? Container()
                  : Image.memory(headedBitMap),
            ),
            Align(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              alignment: Alignment.topRight,
            ),
            editMode == 1
                ? OverflowBox(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleList(
                          origin: Offset(deviceWidth * 0.4, 0),
                          innerRadius: 10,
                          outerRadius: 200,
                          children: List.generate(
                              6,
                              (index) => Container(
                                    width: 100,
                                    height: 50,
                                    child: getIcon(index),
                                  )),
                          centerWidget: GestureDetector(
                            onTap: () {
                              setState(() {
                                editMode = 0;
                              });
                            },
                            child: Image.asset(
                              'assets/images/Filter_Transparent.png',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            editMode = 1;
                          });
                        },
                        child: Image.asset(
                          'assets/images/Filter_Transparent.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
            editMode == -1
                ? OverflowBox(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleList(
                          origin: Offset(-deviceWidth * 0.4, 0),
                          innerRadius: 10,
                          outerRadius: 200,
                          rotateMode: RotateMode.onlyChildrenRotate,
                          showInitialAnimation: true,
                          animationSetting: AnimationSetting(
                            duration: Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn,
                          ),
                          initialAngle: 0,
                          // onDragUpdate: (polarCoord) {
                          //   polarCoord.angle == 0
                          //       ? polarCoord.angle = pi / 3
                          //       : polarCoord.angle = 2 * pi / 3;
                          // },
                          children: List.generate(
                              6,
                              (index) => Container(
                                    width: 100,
                                    height: 50,
                                    child: getIcon(index),
                                  )),
                          centerWidget: GestureDetector(
                            onTap: () {
                              setState(() {
                                editMode = 0;
                              });
                            },
                            child: Image.asset(
                              'assets/images/Brush_Transparent.png',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            editMode = -1;
                          });
                        },
                        child: Image.asset(
                          'assets/images/Brush_Transparent.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget getIcon(int i) {
    switch (i) {
      //Saturation
      case 0:
        return Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: CircleAvatar(
              backgroundColor: Colors.cyan,
              radius: 40,
              child: Icon(
                Icons.flip_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Text(
            'Saturation',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Exposure
      case 1:
        return Row(children: [
          Icon(
            Icons.exposure,
            color: Colors.white,
          ),
          Text(
            'Exposure',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Contrast
      case 2:
        return Row(children: [
          Icon(
            Icons.brightness_medium_rounded,
            color: Colors.white,
          ),
          Text(
            'Contrast',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Brightness
      case 3:
        return Row(children: [
          Icon(
            Icons.wb_sunny_outlined,
            color: Colors.white,
          ),
          Text(
            'Brightness',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Crop
      case 4:
        return Row(children: [
          Icon(
            Icons.crop,
            color: Colors.white,
          ),
          Text(
            'Crop',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Rotate
      case 5:
        return Row(children: [
          Icon(
            Icons.rotate_left,
            color: Colors.white,
          ),
          Text(
            'Rotate',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
      //Saturation

      default:
        return Row(children: [
          Icon(
            Icons.flip_outlined,
            color: Colors.white,
          ),
          Text(
            'Saturation',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ]);
    }
  }
}
