import 'package:android_flickr/screens/PhotoGalleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class CameraRoll extends StatefulWidget {
  @override
  _CameraRollState createState() => _CameraRollState();
}

class _CameraRollState extends State<CameraRoll> {
  bool hasImages = false;

  ///List of all Albums that hold [Image] assets
  Album flickrAlbum;

  ///List of Merged Albums, holding both Images and Videos
  List<Album> gallery = [];

  List<Medium> photos = [];

  List<DateTime> dateTimeList = [];
  List<DateTime> listOfDays = [];

  @override
  void initState() {
    super.initState();
    initGallery();
  }

  Future initGallery() async {
    await PhotoGallery.cleanCache();
    gallery = await PhotoGallery.listAlbums(
      hideIfEmpty: true,
      mediumType: MediumType.image,
    );
    flickrAlbum =
        gallery.firstWhere((element) => element.name == 'Flickr', orElse: null);
    if (flickrAlbum == null) {
      setState(() {
        hasImages = false;
      });
      return;
    }
    await flickrAlbum
        .listMedia(
          newest: true,
        )
        .then((value) => photos = value.items);

    photos.sort(
      (a, b) => a.creationDate.compareTo(b.creationDate),
    );

    for (var i = 0; i < photos.length; i++) {
      dateTimeList.add(photos[i].creationDate);
    }
    DateTime previous = dateTimeList[0];
    for (var i = 0; i < dateTimeList.length; i++) {
      if (i == 0) {
        listOfDays.add(previous);
        continue;
      }
      if (dateTimeList[i].year == previous.year &&
          dateTimeList[i].month == previous.month &&
          dateTimeList[i].day == previous.day) {
        continue;
      }
      listOfDays.add(dateTimeList[i]);
      previous = dateTimeList[i];
    }
    print(listOfDays);

    setState(() {
      hasImages = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: Column(
        children: [
          hasImages
              ? Container()
              : Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Upload your photos!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        'Have you got a lot of photos? We\'ve got a lot of space.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.black,
                        ),
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PhotoGalleryScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Upload now',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
