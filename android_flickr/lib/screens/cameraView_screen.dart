import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

enum FlashMode {
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
class _CameraViewScreenState extends State<CameraViewScreen> {
  //Connection establisher with camera, provided by the camera package.
  CameraController cameraController;
  // a list of device cameras, starts at 0, usually of length 2.
  List allCameras;
  //the physical path of where the photo was saved.
  String photoPath;
  //index of the camera mode chosen by user, 0 = back camera, 1 = front.
  int inUseCamera;
  // flash mode chosen by user.
  FlashMode flashMode = FlashMode.auto;
  // bool that reflects the user choice of either photo or video
  bool isVideoMode = false;

  //method used to initialize the camera
  Future initCamera(CameraDescription cameraDescription) async {
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
  }

  showCameraException(e) {
    String errorText = 'Error ${e.code} \nError message: ${e.description}';
    print(errorText);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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

  Widget previewOfCamera() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
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

  Widget cameraModeButton(String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: GestureDetector(
        onTap: () {
          print('click on camera mode');
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
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
          print('click on flash');
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
      case FlashMode.always:
        return 'assets/images/FlashAlways.png';
        break;
      case FlashMode.auto:
        return 'assets/images/FlashAuto.png';
        break;
      case FlashMode.never:
        return 'assets/images/FlashNever.png';
        break;
      default:
        return 'assets/images/FlashAuto.png';
    }
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
