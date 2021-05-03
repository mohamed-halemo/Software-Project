import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'dart:math';

enum UserFlashMode {
  always,
  auto,
  never,
}

class CameraViewScreen extends StatefulWidget {
  @override
  _CameraViewScreenState createState() => _CameraViewScreenState();
}

/// Camera View Widget, Opens when Camera icon is pressed in home view.
/// method style follows the official example on pub.dev
class _CameraViewScreenState extends State<CameraViewScreen>
    with WidgetsBindingObserver {
  //Connection establisher with camera, provided by the camera package.
  CameraController cameraController;
  // a list of device cameras, starts at 0, usually of length 2.
  List allCameras;
  //the physical path of where the photo was saved.
  String photoPath;
  //index of the camera mode chosen by user, 0 = back camera, 1 = front.
  int inUseCamera;
  // flash mode chosen by user.
  UserFlashMode flashMode = UserFlashMode.auto;
  // bool that reflects the user choice of either photo or video
  bool isVideoMode = false;

  // List of all images on the device (customized to only load the first image, the recent image)
  List<AssetEntity> galleryList;
  // the last image stored on the device
  File recentImage;

  //method used to initialize the camera
  Future initCamera(CameraDescription cameraDescription) async {
    //first initialize gallery list to load recent image
    initGallary();

    //if a camera controller exists, dispose and start a new one
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    try {
      await cameraController.initialize();
    } catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
    cameraController.setFlashMode(FlashMode.auto);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        initCamera(allCameras[inUseCamera]).then((value) {});
      }
    }
  }

  // load list of images and assign the most recent one
  Future initGallary() async {
    await PhotoManager.requestPermission();
    PhotoManager.clearFileCache();
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: [
          OrderOption(
            type: OrderOptionType.createDate,
          )
        ],
      ),
    );

    //only get the first two images, not anymore are needed in this view
    galleryList = await list[0].getAssetListRange(start: 0, end: 1);

    galleryList[0].file.then((value) {
      setState(() {
        recentImage = value;
      });
    });
  }

  //
  showCameraException(e) {
    String errorText =
        'ErrorCode ${e.code} \nError Description: ${e.description}';
    print(errorText);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    //get a lisy of device cameras and initialize to back camera
    availableCameras().then((retrivedList) {
      allCameras = retrivedList;
      if (allCameras.length > 0) {
        setState(() {
          inUseCamera = 0;
        });
        initCamera(allCameras[inUseCamera]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  // refactoring the camera preview size to fit the screen
  Widget previewOfCamera() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return SizedBox();
    }
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.65,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            child: Container(
              width: size.width,
              height: size.height / (4 / 3),
              child: CameraPreview(cameraController),
            ),
          ),
        ),
      ),
    );
  }

  //press to change camera mode, front and back
  Widget cameraModeButton(String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: GestureDetector(
        onTap: () {
          if (inUseCamera == 1) {
            setState(() {
              inUseCamera = 0;
            });
          } else {
            setState(() {
              inUseCamera = 1;
            });
          }
          initCamera(allCameras[inUseCamera]).then((value) {});
        },
        child: inUseCamera == 0
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Transform(
                  transform: Matrix4.rotationY(pi),
                  child: Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
      ),
    );
  }

  Widget flashModeButton(String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: GestureDetector(
        onTap: () {
          if (flashMode == UserFlashMode.always) {
            cameraController.setFlashMode(FlashMode.off);
            setState(() {
              flashMode = UserFlashMode.never;
            });
            return;
          }
          if (flashMode == UserFlashMode.never) {
            cameraController.setFlashMode(FlashMode.auto);
            setState(() {
              flashMode = UserFlashMode.auto;
            });
            return;
          }
          if (flashMode == UserFlashMode.auto) {
            cameraController.setFlashMode(FlashMode.always);
            setState(() {
              flashMode = UserFlashMode.always;
            });
            return;
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            imagePath,
            width: 35,
            height: 35,
          ),
        ),
      ),
    );
  }

  String flashModeSwitchCase() {
    switch (flashMode) {
      case UserFlashMode.always:
        return 'assets/images/FlashAlways.png';
        break;
      case UserFlashMode.auto:
        return 'assets/images/FlashAuto.png';
        break;
      case UserFlashMode.never:
        return 'assets/images/FlashNever.png';
        break;
      default:
        return 'assets/images/FlashAuto.png';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 33),
      body: Container(
        height: deviceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                previewOfCamera(),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: deviceWidth * 0.825),
                  child: Container(
                    height: 50,
                    width: 50,
                    // padding: EdgeInsets.all(10),
                    color: Colors.black38,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 21, 21, 21),
                      height: deviceHeight * 0.09,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.025),
                      child: cameraModeButton('assets/images/CameraMode.png'),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: deviceHeight * 0.025),
                        child: flashModeButton(
                          flashModeSwitchCase(),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 12, 12, 12),
                      height: deviceHeight * 0.125,
                    ),
                    Align(
                      child: GestureDetector(
                        onTap: () {
                          print('click on takePhoto');
                        },
                        child: Container(
                          width: 60,
                          height: deviceHeight * 0.125,
                          decoration: BoxDecoration(
                            color: isVideoMode
                                ? Color.fromARGB(255, 167, 23, 23)
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Align(
                      child: Container(
                        width: 8,
                        height: deviceHeight * 0.125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      alignment:
                          isVideoMode ? Alignment(-0.2, 0) : Alignment(0.2, 0),
                    ),
                    Align(
                      child: Container(
                        padding: EdgeInsets.only(top: deviceHeight * 0.045),
                        width: 30,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVideoMode = false;
                            });
                          },
                          child: Image.asset(
                            isVideoMode
                                ? 'assets/images/Photo_Grey.png'
                                : 'assets/images/Photo.png',
                          ),
                        ),
                      ),
                      alignment: Alignment(0.32, 0),
                    ),
                    Align(
                      child: Container(
                        padding: EdgeInsets.only(top: deviceHeight * 0.045),
                        width: 30,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVideoMode = true;
                            });
                          },
                          child: Image.asset(
                            isVideoMode
                                ? 'assets/images/Video.png'
                                : 'assets/images/Video_Grey.png',
                          ),
                        ),
                      ),
                      alignment: Alignment(-0.32, 0),
                    ),
                    Align(
                      child: Container(
                        padding: EdgeInsets.only(top: deviceHeight * 0.0525),
                        width: 35,
                        height: 70,
                        child: GestureDetector(
                          onTap: () {},
                          child: recentImage == null
                              ? Container(
                                  color: Colors.grey,
                                )
                              : Image.file(
                                  recentImage,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      alignment: Alignment(-0.9, 0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
