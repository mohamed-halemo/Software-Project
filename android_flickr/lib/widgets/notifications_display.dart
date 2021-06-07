import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../Classes/globals.dart' as globals;

class NotificationsDisplay extends StatefulWidget {
  @override
  _NotificationsDisplayState createState() => _NotificationsDisplayState();
}

class _NotificationsDisplayState extends State<NotificationsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: globals.notifications.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: globals.notifications.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  color: Colors.black,
                );
              },
            ),
    );
  }
}
