import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circle_list/circle_list.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'package:bitmap/bitmap.dart';
import 'dart:math';

// import 'package:fab_circular_menu/fab_circular_menu.dart';
// import '../icons/my_flutter_app_icons.dart' as myIcons;
enum BrushMode {
  Saturation,
  Exposure,
  Contrast,
  Brightness,
  Crop,
  Rotate,
}

class PhotoEditScreen extends StatefulWidget {
  final imagePath;
  PhotoEditScreen(this.imagePath);
  @override
  _PhotoEditScreenState createState() => _PhotoEditScreenState();
}

class _PhotoEditScreenState extends State<PhotoEditScreen> {
  Bitmap imageBitMap;
  Uint8List headedBitMap;
  List<Album> imageAlbums;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    initImage();
  }

  initImage() async {
    sliderValue = 0.5;
    imageAlbums = [];
    await PhotoGallery.cleanCache();
    imageAlbums = await PhotoGallery.listAlbums(
      hideIfEmpty: true,
      mediumType: MediumType.image,
    );

    Album workingAlbum =
        imageAlbums.firstWhere((element) => element.name == 'Pictures');

    File file;
    await workingAlbum
        .listMedia(
          newest: true,
        )
        .then(
          (value) => value.items.first.getFile().then((value) => file = value),
        );

    imageBitMap = await Bitmap.fromProvider(FileImage(file));

    setState(() {
      headedBitMap = imageBitMap.buildHeaded();
      dragAngel = 0;
    });
  }

  // is the user editing with brush or filters?
  //if editing, whats edit mode? -1: Brush , 0: Not Editing , 1: Filters
  int editMode = 0;
  double dragAngel;
  double sliderValue;
  BrushMode brushMode = BrushMode.Saturation;

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
                                    child: getIcon(index, true),
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
                          origin: Offset(-deviceWidth * 0.46, 0),
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
                          initialAngle: dragAngel,
                          onDragUpdate: (updateCoord) {
                            dragAngel = updateCoord.angle;
                          },
                          onDragEnd: () {
                            setState(() {});
                          },
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
                                    child: getIcon(index, true),
                                  )),
                          centerWidget: GestureDetector(
                            onTap: () {
                              setState(() {
                                editMode = 0;
                              });
                            },
                            child: Image.asset(
                              'assets/images/Brush_Transparent.png',
                              width: 100,
                              height: 70,
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
            editMode == -1
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      width: deviceWidth * 0.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: getIcon(0, false),
                            ),
                          ),
                          Align(
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayColor: Colors.transparent,
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 0,
                                ),
                              ),
                              child: Slider(
                                value: sliderValue,
                                onChanged: (value) {
                                  setState(() {
                                    sliderValue = value;
                                  });
                                },
                                onChangeEnd: (value) {
                                  applyChanges(brushMode);
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void applyChanges(BrushMode burshMode) {
    switch (brushMode) {
      case BrushMode.Saturation:
        Bitmap saturatedBitmap = imageBitMap.apply(
          BitmapAdjustColor(saturation: sliderValue * 2),
        );
        setState(() {
          headedBitMap = saturatedBitmap.buildHeaded();
        });

        break;
      default:
        Bitmap saturatedBitmap = imageBitMap.apply(
          BitmapAdjustColor(saturation: sliderValue),
        );
        setState(() {
          headedBitMap = saturatedBitmap.buildHeaded();
        });
    }
  }

  Widget getIcon(int i, bool isIcon) {
    switch (i) {
      //Saturation
      case 0:
        return isIcon
            ? Row(mainAxisSize: MainAxisSize.max, children: [
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
              ])
            : Text(
                'Saturation',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Exposure
      case 1:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Exposure',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Contrast
      case 2:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Contrast',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Brightness
      case 3:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Brightness',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Crop
      case 4:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Crop',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Rotate
      case 5:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Rotate',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Saturation

      default:
        return isIcon
            ? Row(children: [
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
              ])
            : Text(
                'Saturation',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
    }
  }
}
