import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

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
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }
    // var camera = cameraController.value;
    // // fetch screen size
    var size = MediaQuery.of(context).size;
    // //
    // var scale = size.aspectRatio * camera.aspectRatio;
    // if (scale < 1) scale = 1 / scale;
    // return
    //     // Transform.scale(
    //     //   scale: scale,
    //     //   child: Container(
    //     //     child: SizedBox(
    //     //       child:
    //     CameraPreview(cameraController);
    // // height: size.height * 0.6,
    // // width: double.infinity,
    // //   ),
    // // ),
    // //);
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

  Widget imageButton(String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: GestureDetector(
        onTap: () {
          print('click on edit');
        },
        child: Image.asset(
          imagePath,
          width: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

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
                Align(
                  alignment: Alignment(0.9, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(10),
                      color: Colors.black38,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
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
                      height: deviceHeight * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.025),
                      child: imageButton('assets/images/CameraMode.png'),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 12, 12, 12),
                      height: deviceHeight * 0.1,
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
