import 'package:flutter/cupertino.dart';

class FlickrGroup {
  String groupName;
  int memberCount;
  int photoCount;
  int discussionCount;
  FlickrGroup({
    @required this.groupName,
    @required this.discussionCount,
    @required this.memberCount,
    @required this.photoCount,
  });
}
