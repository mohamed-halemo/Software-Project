import 'dart:ffi';

import 'package:android_flickr/models/flickr_groups.dart';
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
    if (_init) {
      await Provider.of<YourGroups>(context).mainServerMyGroups();
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<FlickrGroup> groupList = Provider.of<YourGroups>(context).myGroups;
    // print(groupList[0].groupName);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'groupList[index].groupName',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              'Members',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Photos',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Discussions',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
