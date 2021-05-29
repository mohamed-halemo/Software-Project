import 'package:flutter/material.dart';

class NewDiscussion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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
      body: Container(
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
    );
  }
}
