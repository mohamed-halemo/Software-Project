//out of the box imports
import 'package:flutter/material.dart';

///Screen where user can edit a post's description
class EditTitleScreen extends StatefulWidget {
  @override
  EditTitleScreenState createState() => EditTitleScreenState();
}

class EditTitleScreenState extends State<EditTitleScreen> {
  ///Text controller to retrieve values entered
  TextEditingController myTextController;

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
        title: const Text('Edit title'),
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
                  onPressed: () {
                    Navigator.of(context).pop();
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
                hintText: 'Enter title',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                )),
          ),
        ),
      ),
    );
  }
}
