import 'package:flutter/material.dart';
import 'package:path/path.dart';

///A Screen Where the user is able to add tags to a photo he is uploading
//ignore: must_be_immutable
class AddTagsScreen extends StatefulWidget {
  /// A list of all tags associated with the image, No tags : Empty,
  /// this List is passed from the Screen bellow this one in the stack
  List<String> tags;

  ///The list of tags is passed throught the constructor
  AddTagsScreen(this.tags);

  ///Index of the tag to be removed from the tags list
  int currentDeleteIndex = 0;

  ///Text Editing Controller used to get the text entered in the text field
  final myController = TextEditingController();

  ///Adds a tag to [tags] list, the tag is retrieved through the text editing controller,
  /// If textfield is empty, do nothing, if tag already in list, clear textfield and return,
  /// if tag is A,a,i,I , clear textfield, snicker bar(tag is not valid) and return.
  /// if tag is valid, add to tag list, clear textfield and return.
  bool addTag(BuildContext context, String controllerText) {
    if (controllerText.isEmpty) {
      return false;
    }
    if (tags.contains(controllerText)) {
      myController.text = '';
      return false;
    }
    if (controllerText == 'A' ||
        controllerText == 'a' ||
        controllerText == 'i' ||
        controllerText == 'I') {
      var snackBar = SnackBar(
        elevation: 0,
        width: 200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade700,
        content: Text(
          controllerText + ' is not a valid tag.',
          textAlign: TextAlign.center,
        ),
      );

      try {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {}

      myController.text = '';
      return false;
    }

    tags.add(controllerText);

    myController.text = '';

    return true;
  }

  ///Remove a tag from tags list that is at the [currentDeleteIndex] s
  void deleteTag(int index) {
    try {
      tags.removeAt(index);
    } catch (e) {}
  }

  @override
  AddTagsScreenState createState() => AddTagsScreenState();
}

/// State Object that rebuilds with state update
class AddTagsScreenState extends State<AddTagsScreen> {
  ///After default dispose behaviour, dispose of text field controller
  @override
  void dispose() {
    super.dispose();
    widget.myController.dispose();
  }

  ///Build method, rebuilds with every state update.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            Navigator.of(context).pop(widget.tags);
          },
        ),
        title: const Text('Add/remove tags'),
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
                    Navigator.of(context).pop(widget.tags);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey.shade300,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    controller: widget.myController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(8.0),
                      hintText: 'Add a tag',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.add_box_outlined,
                          size: 35,
                        ),
                        onTap: () {
                          setState(() {
                            widget.addTag(context, widget.myController.text);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  50,
              child: ListView.builder(
                itemCount: widget.tags.length,
                itemBuilder: (context, index) {
                  return widget.tags.length == 0
                      ? Container()
                      : Container(
                          height: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        widget.tags[index],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.currentDeleteIndex = index;
                                          var alertDelete = AlertDialog(
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Are you sure you want to delete this tag?',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(),
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.deleteTag(widget
                                                            .currentDeleteIndex);
                                                      });
                                                      widget.currentDeleteIndex =
                                                          -1;
                                                      Navigator.pop(context);
                                                      return;
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      return;
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (_) => alertDelete,
                                            barrierDismissible: true,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                                endIndent: 10,
                                indent: 10,
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
