import 'package:android_flickr/Enums/enums.dart';
import 'package:flutter/material.dart';

class SwitchCaseHelper {
  ///Returns image path of the flash button icon according to chosen Flash mode
  static String getFlashMode(UserFlashMode flashMode) {
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

  ///Return the appropriate icon and text based on the [brushMode],
  ///method takes intiger [i] generated from the list view builder method as well as a bool
  ///[isIcon], if true return both icons and text, esle only return text.
  static Widget getIcon(int i, bool isIcon) {
    switch (i) {
      //Saturation
      case 0:
        return isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.cyan,
                    radius: 30,
                    child: Icon(
                      Icons.flip_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Saturation',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Saturation',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Exposure
      case 1:
        return isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 30,
                    child: Icon(
                      Icons.exposure,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Exposure',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Exposure',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Contrast
      case 2:
        return isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 30,
                    child: Icon(
                      Icons.brightness_medium_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Contrast',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Contrast',
                style: TextStyle(
                  color: Colors.white,
                ),
              );
      //Brightness
      case 3:
        return isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Brightness',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Brightness',
                style: TextStyle(
                  color: Colors.white,
                ),
              );

      //Rotate
      case 4:
        return isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink,
                    radius: 30,
                    child: Icon(
                      Icons.rotate_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rotate',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
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
