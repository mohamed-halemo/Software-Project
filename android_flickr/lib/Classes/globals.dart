///Globals library, has global varibles as well as http handler singleton,
/// used for dependancy injection
library my_prj.globals;

import 'package:bitmap/bitmap.dart';
import 'package:dio/dio.dart';
import '../screens/explore_screen.dart';
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///If true, mockService Url is used, if false, Real Server is used
bool isMockService = false;

String accessToken = '';
String refreshToken = '';

String email;
String password;
bool rememberMe = false;

///http handler for the project. It is a singleton.
class HttpSingleton {
  static final HttpSingleton _singleton = HttpSingleton._internal();

  factory HttpSingleton() {
    return _singleton;
  }

  HttpSingleton._internal();

  ///Returns the base url of the server APIs, returns mock url if isMockService is true.
  ///JSON server was used for mock, it was hosted localy on ip adress with port 3000, Real server
  /// has fotone.me base url
  String getBaseUrl() {
    return isMockService == true ? '192.168.1.11:3000' : 'fotone.me';
  }

  ///uses Refresh token to get new access token, if refresh is expired, post a login request to get new access and refresh
  Future<bool> tokenRefresh() async {
    var url = Uri.https(HttpSingleton().getBaseUrl(),
        isMockService ? '/login/' : 'api/accounts/api/token/refresh/');
    final response = await http.post(url,
        body: json.encode(
          {
            'refresh': refreshToken,
          },
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    // print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      accessToken = data['access'];
      // print('Token Refresh');
      return true;
    } else {
      var url = Uri.https(HttpSingleton().getBaseUrl(),
          isMockService ? '/login/' : 'api/accounts/login/');
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        accessToken = data['tokens']['access'];
        refreshToken = data['tokens']['refresh'];
        // print('Token Login');
        return true;
      }
      // print('failed');
    }
    return false;
  }

  Future<void> postTags(Dio dio, int photoID, List<String> tags) async {
    if (tags.isEmpty) return;
    String tagText = '';
    for (var i = 0; i < tags.length; i++) {
      tagText += tags[i] + ' ';
    }
    var url = Uri.https(HttpSingleton().getBaseUrl(),
        isMockService ? '/login/' : 'api/photos/$photoID/tags');
    print(url);
    final response = await http.post(url,
        body: json.encode(
          {
            'tag_text': tagText,
          },
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + accessToken,
          HttpHeaders.contentTypeHeader: 'application/json'
        });

    // dio.options.headers = {
    //   HttpHeaders.authorizationHeader: 'Bearer ' + accessToken,
    //   HttpHeaders.contentTypeHeader: 'application/json'
    // };

    // try {
    //   await dio.post(
    //     '/api/photos/$photoID/tags',
    //     queryParameters:
    //   ).then((value) {
    //     print(value.data);
    //   });
    // } on DioError catch (e) {
    //   print(e.requestOptions);
    //   print(e.error);
    //   print(e.response.data);
    //   print(e.response.statusMessage);
    //   print(e.response.statusCode);
    // }
  }

  void postAndSaveImage(
      {Bitmap editedBitmap,
      String imageName,
      TextEditingController titleController,
      TextEditingController descriptionController,
      String privacy,
      List<String> tags,
      BuildContext context}) async {
    var imageBytes = editedBitmap.buildHeaded();

    final _imageSaver = ImageSaver();
    await _imageSaver.saveImage(
      imageBytes: imageBytes,
      directoryName: "Flickr",
      imageName: imageName + '.jpg',
    );
    // print(res);
    // print(imageName);

    final directory = await getApplicationDocumentsDirectory();
    File image = await File('${directory.path}/image.jpg').create();
    await image.writeAsBytes(editedBitmap.buildHeaded());
    var decodedImage = await decodeImageFromList(imageBytes);
    // print(decodedImage.width);
    // print(decodedImage.height);

    FormData formData = new FormData.fromMap(
      {
        'title': titleController.text == '' ? imageName : titleController.text,
        'description': descriptionController.text,
        'is_public': privacy == 'Public' ? true : false,
        'photo_width': decodedImage.width,
        'photo_height': decodedImage.height,
        'media_file': await MultipartFile.fromFile(
          image.path,
          // contentType: new MediaType("image", "jpeg"),
        ),
      },
    );

    Dio dio = new Dio(
      BaseOptions(
        baseUrl: 'https://' + HttpSingleton().getBaseUrl(),
      ),
    );
    dio.options.headers = {
      HttpHeaders.authorizationHeader: 'Bearer ' + accessToken,
      HttpHeaders.contentTypeHeader: 'multipart/form-data'
    };

    // print(formData.fields.toString());

    try {
      await dio.post(
        isMockService ? '/photos' : '/api/photos/upload',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      ).then((value) async {
        // print(value);
        await postTags(dio, value.data['id'], tags);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return value;
      });
    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.statusCode);
      if (e.response.statusCode == 401) {
        await HttpSingleton().tokenRefresh().then(
          (value) async {
            try {
              await dio.post(
                isMockService ? '/photos' : '/api/photos/upload',
                data: formData,
                onSendProgress: (int sent, int total) {
                  print('$sent $total');
                },
              ).then((value) async {
                // print(value);
                await postTags(dio, value.data['id'], tags);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return value;
              });
            } on DioError catch (e) {
              print(e.response.data);
              print(e.response.statusCode);
            }
          },
        );
      }
    }
    Navigator.popUntil(context, ModalRoute.withName(ExploreScreen.routeName));
    Navigator.of(context).pushNamed(ExploreScreen.routeName);
  }

  Future<void> postProfileCoverOrPic({
    String imageName,
    String imagePath,
    BuildContext context,
    int updateMode,
  }) async {
    Navigator.popUntil(context, ModalRoute.withName(ExploreScreen.routeName));
    Navigator.of(context).pushNamed(ExploreScreen.routeName);
    File image = File(imagePath);
    var decodedImage = await decodeImageFromList(
      await FileImage(image).file.readAsBytes(),
    );
    // print(decodedImage.width);
    // print(decodedImage.height);

    FormData formData;
    updateMode == 4
        ? formData = new FormData.fromMap(
            {
              'title': imageName,
              'is_public': false,
              'photo_width': decodedImage.width,
              'photo_height': decodedImage.height,
              'cover_photo': await MultipartFile.fromFile(
                image.path,
              ),
            },
          )
        : formData = new FormData.fromMap(
            {
              'title': imageName,
              'is_public': false,
              'photo_width': decodedImage.width,
              'photo_height': decodedImage.height,
              'profile_pic': await MultipartFile.fromFile(
                image.path,
              ),
            },
          );

    Dio dio = new Dio(
      BaseOptions(
        baseUrl: 'https://' + HttpSingleton().getBaseUrl(),
      ),
    );
    dio.options.headers = {
      HttpHeaders.authorizationHeader: 'Bearer ' + accessToken,
      HttpHeaders.contentTypeHeader: 'multipart/form-data'
    };

    // print(formData.fields.toString());

    try {
      await dio.put(
        isMockService
            ? '/photos'
            : updateMode == 4
                ? '/api/accounts/cover-photo'
                : '/api/accounts/profile-pic',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.statusCode);
      if (e.response.statusCode == 401) {
        await HttpSingleton().tokenRefresh().then(
          (value) async {
            try {
              await dio.put(
                isMockService
                    ? '/photos'
                    : updateMode == 4
                        ? '/api/accounts/cover-photo'
                        : '/api/accounts/profile-pic',
                data: formData,
                onSendProgress: (int sent, int total) {
                  print('$sent $total');
                },
              );
            } on DioError catch (e) {
              print(e.response.data);
              print(e.response.statusCode);
            }
          },
        );
      }
    }
    // Navigator.popUntil(context, ModalRoute.withName(ExploreScreen.routeName));
    // Navigator.of(context).pushNamed(ExploreScreen.routeName);
  }
}
