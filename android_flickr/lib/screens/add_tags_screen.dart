import 'package:flutter/material.dart';

//ignore: must_be_immutable
class AddTagsScreen extends StatefulWidget {
  List<String> tags;
  AddTagsScreen(this.tags);
  @override
  _AddTagsScreenState createState() => _AddTagsScreenState();
}

class _AddTagsScreenState extends State<AddTagsScreen> {
  final myController = TextEditingController();
  int currentDeleteIndex = 0;

  void deleteTag() {
    setState(() {
      widget.tags.removeAt(currentDeleteIndex);
    });
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 56, 56),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            Navigator.of(context).pop(widget.tags);
          },
        ),
        title: Text('Add/remove tags'),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
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
                  child: Text(
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
                    controller: myController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Add a tag',
                      hintStyle: TextStyle(
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
                        child: Icon(
                          Icons.add_box_outlined,
                          size: 35,
                        ),
                        onTap: () {
                          addTag();
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
                                          currentDeleteIndex = index;
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
                                                      deleteTag();
                                                      currentDeleteIndex = -1;
                                                      Navigator.pop(context);
                                                      return;
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
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
                                                      style: TextStyle(
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
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
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

  void addTag() {
    if (myController.text.isEmpty) {
      return;
    }
    if (widget.tags.contains(myController.text)) {
      myController.text = '';
      return;
    }
    if (myController.text == 'A' ||
        myController.text == 'a' ||
        myController.text == 'i' ||
        myController.text == 'I') {
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
          myController.text + ' is not a valid tag.',
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      myController.text = '';
      return;
    }
    setState(() {
      widget.tags.add(myController.text);
    });
    myController.text = '';
    return;
  }
}
