//out of the box imports
import 'dart:io';
import 'dart:typed_data';

//packages and Plugins
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:bitmap/bitmap.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';

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
  PhotoEditScreenState createState() => PhotoEditScreenState();
}

class PhotoEditScreenState extends State<PhotoEditScreen> {
  ///Holds a bitmap of the chosen or Captured image.
  Bitmap imageBitMap;

  ///Used to display the changes to the user, without overwriting the orignal bitmap.
  Bitmap editedBitMap;

  /// 0 = no rotation, 1 = clock wise, -1 = anti clock wise, 2 or -2 = 180 degrees
  int rotationApplied = 0;
  int actualRotationApplied = 0;

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

  List<double> sliderValueList;

  ///The Editing mode state variable
  BrushMode brushMode;

  ///An intiger that counts how many changes has occured due to rotating the wheel
  int brushModeChangeOnAngleUpdate;

  ///A double that keeps track of how far the wheel has rotated
  double totalAngleOfRotation;

  ///A double that holds the last angle of the wheel, subtract from drag angle and get absolute
  ///to get total angle of rotation
  double oldAngel;

  bool resetAllEnabler = false;
  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  ///Initialize State variables and hide notifications panel then Load the image
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    brushMode = BrushMode.Saturation;
    totalAngleOfRotation = 0;
    oldAngel = 0;
    dragAngel = 0;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    sliderValue = 0.5;
    sliderValueList = [
      0.5,
      0.5,
      0.5,
      0.5,
    ];
    imageAlbums = [];
    initImage();
    setState(() {});
  }

  ///clear previous cache and load image as a file from [Pictures] folder then
  ///convert it into a [Bitmap] and build a headed [Uint8List] from this map.
  initImage() async {
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
                  if (editedBitMap == null) {
                    editedBitMap = imageBitMap;
                  }
                  SystemChrome.setPreferredOrientations(
                    [
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PhotoUploadScreen(
                        headedBitMap,
                        editedBitMap,
                      ),
                    ),
                  );
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
            editMode == -1
                ? OrientationBuilder(
                    builder: (context, orientation) {
                      return OverflowBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: orientation == Orientation.portrait
                                ? MediaQuery.of(context).size.width * 0.2
                                : MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CircleListScrollView(
                              renderChildrenOutsideViewport: true,
                              physics: CircleFixedExtentScrollPhysics(),
                              clipToSize: false,
                              axis: Axis.vertical,
                              itemExtent: 150,
                              children: List.generate(
                                5,
                                (index) =>
                                    SwitchCaseHelper.getIcon(index, true),
                              ),
                              radius: orientation == Orientation.portrait
                                  ? MediaQuery.of(context).size.height * 0.2
                                  : MediaQuery.of(context).size.height * 0.3,
                              onSelectedItemChanged: (value) {
                                setBrushState(value);
                              },
                            ),
                          ),
                        ),
                      );
                    },
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              editMode = 0;
                              brushMode = BrushMode.Saturation;
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
                  )
                : Container(),
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
                                  child: getSlider(),
                                ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            resetAllEnabler
                ? Align(
                    child: GestureDetector(
                      onTap: () {
                        for (var i = 0; i < sliderValueList.length; i++) {
                          sliderValueList[i] = 0.5;
                        }
                        rotationApplied = 0;
                        setState(() {
                          applyChanges(brushMode);
                          resetAllEnabler = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Reset All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget getSlider() {
    resetAllEnabler = false;
    for (var i = 0; i < sliderValueList.length; i++) {
      if (sliderValueList[i] != 0.5) {
        resetAllEnabler = true;

        break;
      }
    }
    switch (brushMode) {
      case BrushMode.Saturation:
        return Slider(
          value: sliderValueList[0],
          onChanged: (value) {
            setState(() {
              sliderValueList[0] = value;
            });
          },
          onChangeEnd: (value) {
            applyChanges(brushMode);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        );
      case BrushMode.Exposure:
        return Slider(
          value: sliderValueList[1],
          onChanged: (value) {
            setState(() {
              sliderValueList[1] = value;
            });
          },
          onChangeEnd: (value) {
            applyChanges(brushMode);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        );
      case BrushMode.Contrast:
        return Slider(
          value: sliderValueList[2],
          onChanged: (value) {
            setState(() {
              sliderValueList[2] = value;
            });
          },
          onChangeEnd: (value) {
            applyChanges(brushMode);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        );
      case BrushMode.Brightness:
        return Slider(
          value: sliderValueList[3],
          onChanged: (value) {
            setState(() {
              sliderValueList[3] = value;
            });
          },
          onChangeEnd: (value) {
            applyChanges(brushMode);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        );

      default:
        return Slider(
          value: sliderValueList[0],
          onChanged: (value) {
            setState(() {
              sliderValueList[0] = value;
            });
          },
          onChangeEnd: (value) {
            applyChanges(brushMode);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
        );
    }
  }

  ///Returns a Row of Icons Depending on the edit mode, if Crop, return crop options,
  ///if Rotate, return rotation arrows.
  //
  //Crop was dropped in phase 3 as a part of the dropped 50%
  Widget getRotateOrCrop() {
    Bitmap editedBitmap = imageBitMap;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(
              Icons.rotate_left_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              editedBitmap = editedBitmap.apply(
                BitmapRotate.rotateCounterClockwise(),
              );

              rotationApplied--;
              if (rotationApplied == -3) {
                rotationApplied = 1;
              }
              actualRotationApplied = rotationApplied;
              setState(() {
                if (actualRotationApplied != 0) {
                  resetAllEnabler = true;
                } else {
                  resetAllEnabler = false;
                }
                headedBitMap = editedBitmap.buildHeaded();
                imageBitMap = editedBitmap;
                applyChanges(brushMode);
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
              editedBitmap = editedBitmap.apply(
                BitmapRotate.rotateClockwise(),
              );
              rotationApplied++;
              if (rotationApplied == 3) {
                rotationApplied = -1;
              }
              actualRotationApplied = rotationApplied;
              setState(() {
                if (actualRotationApplied != 0) {
                  resetAllEnabler = true;
                } else {
                  resetAllEnabler = false;
                }
                headedBitMap = editedBitmap.buildHeaded();
                imageBitMap = editedBitmap;
                applyChanges(brushMode);
              });
            }),
      ],
    );
  }

  ///Set the brushMode state variable depending on the Angle of rotation of the
  ///List wheel.
  void setBrushState(int angle) {
    if (angle == 0) {
      setState(() {
        brushMode = BrushMode.Saturation;
      });
    }

    if (angle == 1) {
      setState(() {
        brushMode = BrushMode.Exposure;
      });
    }
    if (angle == 2) {
      setState(() {
        brushMode = BrushMode.Contrast;
      });
    }
    if (angle == 3) {
      setState(() {
        brushMode = BrushMode.Brightness;
      });
    }
    if (angle == 4) {
      setState(() {
        brushMode = BrushMode.Rotate;
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
    if (rotationApplied == 0 && rotationApplied != actualRotationApplied) {
      switch (actualRotationApplied) {
        case 1:
          imageBitMap =
              imageBitMap.apply(BitmapRotate.rotateCounterClockwise());
          break;
        case -1:
          imageBitMap = imageBitMap.apply(BitmapRotate.rotateClockwise());
          break;
        case 2:
          imageBitMap = imageBitMap.apply(BitmapRotate.rotateClockwise());
          imageBitMap = imageBitMap.apply(BitmapRotate.rotateClockwise());
          break;
        case -2:
          imageBitMap = imageBitMap.apply(BitmapRotate.rotateClockwise());
          imageBitMap = imageBitMap.apply(BitmapRotate.rotateClockwise());
          break;
        default:
      }
      actualRotationApplied = 0;
    }
    editedBitMap = imageBitMap.apply(
      BitmapAdjustColor(saturation: sliderValueList[0] * 2),
    );
    editedBitMap = editedBitMap.apply(
      BitmapAdjustColor(exposure: sliderValueList[1] * 4 - 2),
    );
    editedBitMap = editedBitMap.apply(
      BitmapContrast(sliderValueList[2] * 2),
    );
    editedBitMap = editedBitMap.apply(
      BitmapBrightness(sliderValueList[3] - 0.5),
    );

    setState(() {
      headedBitMap = editedBitMap.buildHeaded();
    });
  }
}
