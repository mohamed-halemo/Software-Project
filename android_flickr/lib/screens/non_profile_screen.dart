import 'package:android_flickr/widgets/tabbar_in_non_profile.dart';
import 'package:flutter/material.dart';

class NonProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.033,
          ),
          child: NestedScrollView(
            headerSliverBuilder: (context, index) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        background: Image.asset(
                          'assets/images/Logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.2,
                        left: MediaQuery.of(context).size.width * 0.4,
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
            body: TabbarInNonProfile(),
          ),
        ),
      ),
    );
  }
}
