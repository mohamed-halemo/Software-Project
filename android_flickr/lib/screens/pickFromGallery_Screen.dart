import 'package:android_flickr/screens/flickr_Camera_Screen.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class PhotoGallery extends StatefulWidget {
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<AssetPathEntity> galleryList = [];
  List<List<AssetEntity>> galleryImplicitList = [];
  var firstImagesList;
  List<int> imageCountList = [];
  List<int> videoCountList = [];

  Future initGallary() async {
    await PhotoManager.requestPermission();
    PhotoManager.clearFileCache();
    int imageCount = 0;
    int videoCount = 0;

    galleryList = await PhotoManager.getAssetPathList(
      onlyAll: false,
      filterOption: FilterOptionGroup(
        orders: [
          OrderOption(
            type: OrderOptionType.createDate,
          )
        ],
      ),
    );
    List<File> tempList = new List<File>(galleryList.length);
    List<int> tempListImage = new List<int>(galleryList.length);
    List<int> tempListVideo = new List<int>(galleryList.length);
    for (var i = 0; i < galleryList.length; i++) {
      galleryList[i].assetList.then((value) => value[0].file.then(
            (value2) {
              if (value[0].type == AssetType.other) {
                for (var j = 1; j < value.length; j++) {
                  if (value[j].type != AssetType.other) {
                    value[j].file.then((value3) {
                      setState(() {
                        tempList[i] = value3;
                      });
                      return;
                    });
                  }
                }
              }
              setState(() {
                tempList[i] = value2;
              });
            },
          ));

      firstImagesList = tempList;
      galleryList[i].assetList.then((value) {
        for (var j = 0; j < value.length; j++) {
          if (value[j].type == AssetType.image) {
            imageCount++;
            break;
          }
          if (value[j].type == AssetType.video) {
            videoCount++;
            break;
          }
          if (value[j].type == AssetType.other) {
            break;
          }
        }
        tempListImage[i] = imageCount;
        tempListVideo[i] = videoCount;
      });
    }
    imageCountList = tempListImage;
    videoCountList = tempListVideo;
  }

  String getImagesVideos(int index) {
    String returnedString;
    if (imageCountList[index] == 0 && videoCountList[index] != 0) {
      returnedString = videoCountList[index] == 1
          ? '${videoCountList[index]} video'
          : '${videoCountList[index]} videos';

      return returnedString;
    } else if (videoCountList[index] == 0 && imageCountList[index] != 0) {
      returnedString = imageCountList[index] == 1
          ? '${imageCountList[index]} photo'
          : '${imageCountList[index]} photos';
      return returnedString;
    } else {
      returnedString = imageCountList[index] == 1
          ? '${imageCountList[index]} photo '
          : '${imageCountList[index]} photos ';
      returnedString = returnedString +
          (videoCountList[index] == 1
              ? '${videoCountList[index]} video'
              : '${videoCountList[index]} videos');
      return returnedString;
    }
  }

  @override
  void initState() {
    super.initState();
    initGallary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              child: ListTile(
                leading: Text(
                  'Photo Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FlickrCameraScreen(),
                        ));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${galleryList.length} folders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 0.1,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: 18,
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey,
            ),
            ListView.builder(
              itemExtent: 70,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: firstImagesList == null ? 0 : firstImagesList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  color: index % 2 == 0
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Colors.grey.shade900,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {},
                            child: Container(
                              width: 70,
                              height: 70,
                              alignment: Alignment.centerLeft,
                              child: firstImagesList[index] == null
                                  ? Container()
                                  : ClipRect(
                                      child: Image.file(
                                        firstImagesList[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${galleryList[index].name}',
                              style: TextStyle(
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            Text(
                              getImagesVideos(index),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 2,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
