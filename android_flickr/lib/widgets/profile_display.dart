import 'package:flutter/material.dart';
import './tabbar_in_profile.dart';

/// Profile of the user which includes their avatar, followers and following and a tabbar.
class ProfileDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, index) {
        return [
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () {},
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("nice"),
                    ),
                    PopupMenuItem(
                      child: Text("bad"),
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
                    backgroundImage: AssetImage(
                      'assets/images/Logo.png',
                    ),
                  ),
                ),
              ],
            ),
            expandedHeight: 200,
          ),
        ];
      },

      /// Tabbar (public,camera roll,groups...) that is nested in the main tabbar.
      body: TabbarInProfile(),
    );
  }
}
