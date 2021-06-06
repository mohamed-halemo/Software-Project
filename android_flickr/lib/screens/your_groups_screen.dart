import 'dart:ffi';

import 'package:android_flickr/models/flickr_groups.dart';
import 'package:android_flickr/screens/group_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_groups.dart';
import 'package:flutter/services.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  var _init = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_init) {
      await Provider.of<YourGroups>(context).mainServerMyGroups();
    }
    setState(() {
      _init = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FlickrGroup> groupList = Provider.of<YourGroups>(context).myGroups;
    //print(groupList[0].groupName);
    return _init
        ? Container()
        : Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
            ),
            child: ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupView(
                            groupList[index].id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 120,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: CircleAvatar(
                              radius: 43,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                'https://picsum.photos/400/600',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          VerticalDivider(
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  groupList[index].groupName,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        groupList[index]
                                                .memberCount
                                                .toString() +
                                            ' Members',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        groupList[index].photoCount.toString() +
                                            ' Photos',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        groupList[index]
                                                .discussionCount
                                                .toString() +
                                            ' Discussions',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
