import 'package:flutter/material.dart';
// import 'package:path/path.dart';

/// Comments page
class Comments extends StatefulWidget {
  @override
  CommentsState createState() => CommentsState();
}

class CommentsState extends State<Comments> {
  List<String> comments = [];

  /// Adding new comments to the comments page
  void addComment(String val) {
    setState(() {
      comments.add(val);
    });
  }

  /// Building the comments list and return the comment in it's position
  Widget buildCommentList() {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (Context, index) {
        return buildCommentItem(comments[index]);
      },
    );
  }

  /// returns the text of the comment in lists
  Widget buildCommentItem(String comment) {
    return ListTile(
      title: Text(comment),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildCommentList(),
          ),
          TextField(
            onSubmitted: (String submittedStr) {
              addComment(submittedStr);
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Add comment'),
          )
        ],
      ),
    );
  }
}
