import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraViewScreen extends StatefulWidget {
  @override
  _CameraViewScreenState createState() => _CameraViewScreenState();
}

/// Camera View Widget, Opens when Camera icon is pressed in home view.
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
  }

  @override
  void initState() {
    super.initState();
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

    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 33),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: previewOfCamera(),
                )
              ],
            ),
            Row(),
            Row(),
          ],
        ),
      ),
    );
  }
}
