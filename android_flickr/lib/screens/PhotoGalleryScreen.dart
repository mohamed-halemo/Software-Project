import 'package:android_flickr/screens/flickr_Camera_Screen.dart';
import 'package:flutter/material.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:photo_gallery/photo_gallery.dart';
// import 'package:transparent_image/transparent_image.dart';

// import 'dart:io';
import 'dart:typed_data';

class PhotoGalleryScreen extends StatefulWidget {
  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  List<Album> imageAlbums;
  List<Album> videoAlbums;
  List<Album> gallery = [];
  List<List<int>> albumThumbnailData = [];

  List<bool> greyTile = [];
  int folderCount = 0;

  //gallery initialization and creating all needed lists
  Future initGallary() async {
    await PhotoGallery.cleanCache();
    imageAlbums = await PhotoGallery.listAlbums(
      hideIfEmpty: true,
      mediumType: MediumType.image,
    );
    videoAlbums = await PhotoGallery.listAlbums(
      hideIfEmpty: true,
      mediumType: MediumType.video,
    );
    for (var i = 0; i < imageAlbums.length; i++) {
      if (imageAlbums[i].isAllAlbum) {
        continue;
      }
      gallery.add(imageAlbums[i]);
    }
    for (var i = 0; i < videoAlbums.length; i++) {
      if (videoAlbums[i].isAllAlbum) {
        continue;
      }
      gallery.add(videoAlbums[i]);
    }
    gallery.sort((x, y) {
      if (x.name == null) return 0;
      if (y.name == null) return 0;

      if (x.name == 'Download' || x.name == 'Downloads') return -1;
      if (y.name == 'Download' || y.name == 'Downloads') return -1;
      return x.name.toLowerCase().compareTo(y.name.toLowerCase());
    });

    // for (var i = 0; i < gallery.length; i++) {
    //   print(gallery[i].name);
    // }
    bool tempGreyTile = true;
    for (var i = 0; i < gallery.length; i++) {
      await PhotoGallery.getAlbumThumbnail(
        height: 70,
        width: 70,
        highQuality: true,
        albumId: gallery[i].id,
      ).then((value) => albumThumbnailData.add(value));
      folderCount++;
      greyTile.add(tempGreyTile);
      tempGreyTile = !tempGreyTile;
      if (gallery.length > i + 1) {
        if (gallery[i].name == gallery[i + 1].name) {
          i++;
          tempGreyTile = !tempGreyTile;
        }
      }
    }

    setState(() {});
  }

  String getImagesVideos(int index) {
    String returnedString = '';
    if (gallery[index].mediumType == MediumType.image) {
      var imageCount = gallery[index].count;
      var videoCount = 0;
      if (gallery.length - 1 > index) {
        if (gallery[index].name == gallery[index + 1].name) {
          videoCount = gallery[index + 1].count;
        }
      }
      if (imageCount == 0 && videoCount != 0) {
        returnedString =
            videoCount == 1 ? '$videoCount video' : '$videoCount videos';

        return returnedString;
      } else if (videoCount == 0 && imageCount != 0) {
        returnedString =
            imageCount == 1 ? '$imageCount photo' : '$imageCount photos';
        return returnedString;
      } else {
        returnedString =
            imageCount == 1 ? '$imageCount photo ' : '$imageCount photos ';
        returnedString = returnedString +
            (videoCount == 1 ? '$videoCount video' : '$videoCount videos');
        return returnedString;
      }
    }
    if (gallery[index].mediumType == MediumType.video) {
      var videoCount = gallery[index].count;
      returnedString =
          videoCount == 1 ? '$videoCount video' : '$videoCount videos';
    }
    return returnedString;
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
                  '$folderCount folders',
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: gallery.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return (0 < index &&
                            gallery[index].name == gallery[index - 1].name ||
                        index >= albumThumbnailData.length)
                    ? SizedBox(height: 0)
                    : Container(
                        color: greyTile[index]
                            ? Color.fromARGB(255, 0, 0, 0)
                            : Colors.grey.shade900,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.centerLeft,
                                child: FadeInImage(
                                  fit: BoxFit.fitWidth,
                                  placeholder: MemoryImage(
                                    Uint8List.fromList(
                                        albumThumbnailData[index]),
                                  ),
                                  image: AlbumThumbnailProvider(
                                    albumId: gallery[index].id,
                                    width: 1000,
                                    height: 1000,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 70,
                                top: 20,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${gallery[index].name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 70,
                                top: 30,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  getImagesVideos(index),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
