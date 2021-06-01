import 'package:flutter/material.dart';
import '../widgets/groups_tab_bar.dart';

/// Group view including photos and discussions
class GroupView extends StatefulWidget {
  @override
  GroupViewState createState() => GroupViewState();
}

class GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, index) {
        return [
          SliverAppBar(
            floating: false,
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton(
                itemBuilder: (contex) {
                  return [
                    PopupMenuItem(
                      child: Text('Leave group'),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.43,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                  ),
                )
              ],
            ),
            expandedHeight: 120,
          ),
        ];
      },
      body: GroupsTabBar(),
    );
  }
}
