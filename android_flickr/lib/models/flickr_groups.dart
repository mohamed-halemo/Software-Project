import 'package:flutter/cupertino.dart';

class FlickrGroup {
  int id;
  String groupName;
  int memberCount;
  int photoCount;
  int discussionCount;
  FlickrGroup({
    @required this.id,
    @required this.groupName,
    @required this.discussionCount,
    @required this.memberCount,
    @required this.photoCount,
  });
}
