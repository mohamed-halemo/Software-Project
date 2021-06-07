//out of the box imports
import 'package:flutter/material.dart';
import '../Classes/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

///Screen where user can edit a post's description
class EditDescriptionScreen extends StatefulWidget {
  ///Id of the Post to be edited
  final id;

  ///get post id through constructor
  EditDescriptionScreen(this.id);
  @override
  EditDescriptionScreenState createState() => EditDescriptionScreenState();
}

class EditDescriptionScreenState extends State<EditDescriptionScreen> {
  ///Text controller to retrieve values entered
  final myTextController = TextEditingController();

  ///main build method, rebuilds with state update
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Edit description'),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    Uri url = Uri.https(globals.HttpSingleton().getBaseUrl(),
                        '/api/photos/${widget.id}/meta');

                    await http.put(
                      url,
                      body: json.encode(
                        {
                          'description': myTextController.text,
                        },
                      ),
                      headers: {
                        HttpHeaders.authorizationHeader:
                            'Bearer ' + globals.accessToken,
                        HttpHeaders.contentTypeHeader: 'application/json'
                      },
                    ).then((value) {
                      print(value.statusCode);
                      Navigator.of(context).pop(true);
                    });
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: double.infinity,
          color: Colors.grey.shade300,
          child: TextFormField(
            minLines: 100,
            maxLines: 101,
            controller: myTextController,
            decoration: InputDecoration(
                hintText: 'Enter description',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                )),
          ),
        ),
      ),
    );
  }
}
