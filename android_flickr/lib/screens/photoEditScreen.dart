//out of the box imports
import 'dart:io';
import 'dart:typed_data';
//packages and Plugins

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circle_list/circle_list.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:bitmap/bitmap.dart';

//Personal Imports
import 'package:android_flickr/screens/PhotoUploadScreen.dart';
import 'package:android_flickr/Enums/enums.dart';
import '../Classes/switch_Case_Helper.dart';

///Photo Editing Screen, Can be Opened after taking a picture using the Camera Screen
///or can be opened from the Photo Screen using the Edit photo button.
class PhotoEditScreen extends StatefulWidget {
  ///Path and name of the image
  final imagePath;

  ///Constructs the photo edit screen settting the imagePath variable.
  PhotoEditScreen(this.imagePath);
  @override
  _PhotoEditScreenState createState() => _PhotoEditScreenState();
}

class _PhotoEditScreenState extends State<PhotoEditScreen> {
  ///Holds a bitmap of the chosen or Captured image.
  Bitmap imageBitMap;

  ///Used to display the changes to the user, without overwriting the orignal bitmap.
  Bitmap editedBitMap;

  ///Used to display the image on the screen after converting it from [Bitmap] to [Uint8List]
  Uint8List headedBitMap;

  ///A list of Albums on the phone, used to Load the to be edited image.
  List<Album> imageAlbums;

  /// is the user editing with brush or filters?
  ///if editing, what is the edit mode? -1: Brush , 0: Not Editing , 1: Filters
  int editMode = 0;

  ///Drag angle of the list wheel
  double dragAngel;

  ///Slider Value of some editing modes
  double sliderValue;

  ///The Editing mode state variable
  BrushMode brushMode;

  ///An intiger that counts how many changes has occured due to rotating the wheel
  int brushModeChangeOnAngleUpdate;

  ///A double that keeps track of how far the wheel has rotated
  double totalAngleOfRotation;

  ///A double that holds the last angle of the wheel, subtract from drag angle and get absolute
  ///to get total angle of rotation
  double oldAngel;

  ///Initialize State variables and hide notifications panel then Load the image
  @override
  void initState() {
    super.initState();
    brushMode = BrushMode.Saturation;
    totalAngleOfRotation = 0;
    oldAngel = 0;
    dragAngel = 0;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    sliderValue = 0.5;
    imageAlbums = [];
    initImage();
    setState(() {});
  }

  ///clear previous cache and load image as a file from [Pictures] folder then
  ///convert it into a [Bitmap] and build a headed [Uint8List] from this map.
  initImage() async {
    // await PhotoGallery.cleanCache();
    // imageAlbums = await PhotoGallery.listAlbums(
    //   hideIfEmpty: true,
    //   mediumType: MediumType.image,
    // );

    // Album workingAlbum =
    //     imageAlbums.firstWhere((element) => element.name == 'Pictures');

    // File file;
    // await workingAlbum
    //     .listMedia(
    //       newest: true,
    //     )
    //     .then(
    //       (value) => value.items.first.getFile().then((value) => file = value),
    //     );

    // imageBitMap = await Bitmap.fromProvider(FileImage(file));
    imageBitMap = await Bitmap.fromProvider(FileImage(File(widget.imagePath)));
    setState(() {
      headedBitMap = imageBitMap.buildHeaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final deviceHeight = MediaQuery.of(context).size.height;
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PhotoUploadScreen(headedBitMap)));
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
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
                                    child:
                                        SwitchCaseHelper.getIcon(index, true),
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
                          initialAngle: 0,
                          onDragStart: (_) {
                            imageBitMap = editedBitMap;
                            oldAngel = 0;
                            dragAngel = 0;
                          },
                          onDragUpdate: (updateCoord) {
                            oldAngel = dragAngel;
                            dragAngel = updateCoord.angle;
                            totalAngleOfRotation =
                                totalAngleOfRotation + (dragAngel - oldAngel);
                            if (totalAngleOfRotation >= 6.2)
                              totalAngleOfRotation = 0;
                            setState(() {
                              print('ZAKA: ' + totalAngleOfRotation.toString());
                              setBrushState(totalAngleOfRotation);
                            });
                          },
                          children: List.generate(
                              6,
                              (index) => Container(
                                    width: 100,
                                    height: 50,
                                    child: SwitchCaseHelper.getIcon(
                                        6 - index, true),
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
                              child: SwitchCaseHelper.getIcon(
                                  brushMode.index, false),
                            ),
                          ),
                          brushMode == BrushMode.Crop ||
                                  brushMode == BrushMode.Rotate
                              ? getRotateOrCrop()
                              : SliderTheme(
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

  ///Returns a Row of Icons Depending on the edit mode, if Crop, return crop options,
  ///if Rotate, return rotation arrows.
  //
  //Crop was dropped in phase 3 as a part of the dropped 50%
  Widget getRotateOrCrop() {
    Bitmap editedBitmap = imageBitMap;
    return brushMode == BrushMode.Rotate
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.rotate_left_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    editedBitmap = imageBitMap.apply(
                      BitmapRotate.rotateCounterClockwise(),
                    );
                    setState(() {
                      headedBitMap = editedBitmap.buildHeaded();
                      imageBitMap = editedBitmap;
                    });
                  }),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  icon: Icon(
                    Icons.rotate_right_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    editedBitmap = imageBitMap.apply(
                      BitmapRotate.rotateClockwise(),
                    );
                    setState(() {
                      headedBitMap = editedBitmap.buildHeaded();
                      imageBitMap = editedBitmap;
                    });
                  }),
            ],
          )
        : Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.crop_portrait_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  editedBitmap = imageBitMap.apply(BitmapCrop.fromLTWH(
                    left: 100,
                    top: 100,
                    width: 300,
                    height: 100,
                  ));
                  setState(() {
                    headedBitMap = editedBitmap.buildHeaded();
                  });
                },
              ),
            ],
          );
  }

  ///Set the brushMode state variable depending on the Angle of rotation of the
  ///List wheel.
  void setBrushState(double angle) {
    if ((angle).abs() >= 0 && (angle).abs() <= 0.1) {
      setState(() {
        brushMode = BrushMode.Saturation;
        sliderValue = 0.5;
      });
    }

    if ((angle).abs() >= 0.95 && (angle).abs() <= 1.1) {
      setState(() {
        brushMode = BrushMode.Exposure;
        sliderValue = 0.5;
      });
    }
    if ((angle).abs() >= 1.9 && (angle).abs() <= 2.2) {
      setState(() {
        brushMode = BrushMode.Contrast;
        sliderValue = 0.5;
      });
    }
    if ((angle).abs() >= 3 && (angle).abs() <= 3.3) {
      setState(() {
        brushMode = BrushMode.Brightness;
        sliderValue = 0.5;
      });
    }
    if ((angle).abs() >= 4.15 && (angle).abs() <= 4.3) {
      setState(() {
        brushMode = BrushMode.Crop;
        sliderValue = 0.5;
      });
    }
    if ((angle).abs() >= 5.2 && (angle).abs() <= 5.3) {
      setState(() {
        brushMode = BrushMode.Rotate;
        sliderValue = 0.5;
      });
    }
  }

  ///Apply changes the user wants on the Bitmap and update the displayed headed bitmap accordingly.
  ///The method Takes [brushMode] as a parameter and uses the local [sliderValue] variable
  /// as enhancment factor for the image.
  void applyChanges(BrushMode burshMode) async {
    if (imageBitMap == null) {
      await initImage();
    }
    switch (brushMode) {
      case BrushMode.Saturation:
        editedBitMap = imageBitMap.apply(
          BitmapAdjustColor(saturation: sliderValue * 2),
        );
        setState(() {
          headedBitMap = editedBitMap.buildHeaded();
        });
        break;
      case BrushMode.Exposure:
        editedBitMap = imageBitMap.apply(
          BitmapAdjustColor(exposure: sliderValue * 4 - 2),
        );
        setState(() {
          headedBitMap = editedBitMap.buildHeaded();
        });
        break;
      case BrushMode.Contrast:
        editedBitMap = imageBitMap.apply(
          BitmapContrast(sliderValue * 2),
        );
        setState(() {
          headedBitMap = editedBitMap.buildHeaded();
        });
        break;
      case BrushMode.Brightness:
        editedBitMap = imageBitMap.apply(
          BitmapBrightness(sliderValue - 0.5),
        );
        setState(() {
          headedBitMap = editedBitMap.buildHeaded();
        });
        break;
      default:
        editedBitMap = imageBitMap.apply(
          BitmapAdjustColor(saturation: sliderValue),
        );
        setState(() {
          headedBitMap = editedBitMap.buildHeaded();
        });
    }
  }
}
