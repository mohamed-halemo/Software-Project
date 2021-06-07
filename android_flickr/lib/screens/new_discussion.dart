import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

///New discussion in groups page
class NewDiscussion extends StatefulWidget {
  @override
  _NewDiscussionState createState() => _NewDiscussionState();
}

///A key used in validating the text inputed by the user,
///manily to make sure the text input form is not empty
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _NewDiscussionState extends State<NewDiscussion> {
  @override
  Widget build(BuildContext context) {
    void _showError(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(message),
          actions: <Widget>[
            Divider(),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Colors.grey[900],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 12, top: 12),
            child: Container(
              width: 65,
              child: FlatButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {}
                },
                child: Text('Post'),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Title',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.grey[300],
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Your post needs to have both a title and a description.';
                    }
                    return null;
                  },
                  cursorColor: Colors.green[800],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.grey[300],
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Your post needs to have both a title and a description.';
                    }
                    return null;
                  },
                  cursorColor: Colors.green[800],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
