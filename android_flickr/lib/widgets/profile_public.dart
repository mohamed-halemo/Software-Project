import 'package:android_flickr/widgets/public_view_grid.dart';
import 'package:android_flickr/widgets/public_view_post.dart';
import 'package:flutter/material.dart';
//import 'package:android_flickr/widgets/explore_post.dart';

//import '../providers/flickr_posts.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

/// Public that is cuztomized for the user to display his/her posts in grid view or list view.
class ProfilePublic extends StatefulWidget {
  @override
  _ProfilePublicState createState() => _ProfilePublicState();
}

class _ProfilePublicState extends State<ProfilePublic> {
  ScrollController _controller = ScrollController();

  /// To know whether to hide the grid/list view options or know based on user scrolling.
  bool closeTopContainer = false;
  bool postView = false;
  bool gridView = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      /// If user swiped up for certain amount the container of the grid/list view options is hidden.
      setState(() {
        closeTopContainer = _controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final postsToDisplay = Provider.of<Posts>(context).posts;
    return Container(
      decoration: BoxDecoration(
        color: postView ? Colors.black.withOpacity(0.9) : Colors.white,
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: closeTopContainer
                ? 0
                : MediaQuery.of(context).size.height * 0.05,
            child: Container(
              //width: MediaQuery.of(context).size.width - 20,
              color: Colors.grey.shade400,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.indeterminate_check_box),
                    color: gridView == true ? Colors.black54 : Colors.white,
                    onPressed: () {
                      setState(() {
                        postView = false;
                        gridView = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.crop_square_outlined),
                    color: postView == true ? Colors.black54 : Colors.white,
                    onPressed: () {
                      setState(
                        () {
                          postView = true;
                          gridView = false;
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),

          /// Display the Listview of the posts like in explore mode.
          if (postView) Expanded(child: PublicViewPost()),

          /// Display the gridview which displays only the images of the post close to each other.
          if (gridView) Expanded(child: PublicViewGrid()),
          /*  Expanded(
            child: ListView.builder(
              //controller: _controller,
              itemCount: postsToDisplay.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: postsToDisplay[index],
                  child: ExplorePost(),
                );
              },
            ),
          ), */
        ],
      ),
    );
  }
}

/* Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            SliverAppBar(
              elevation: 0,
              toolbarHeight: 0,
              floating: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey.shade900,
            )
          ];
        },
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.indeterminate_check_box),
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.crop_square_outlined),
                    color: Colors.grey,
                    onPressed: () {},
                  )
                ],
              ),
              Expanded(child: PublicViewPost()),
              //PublicViewGrid(),
            ],
          ),
        ),
      ),
    ); */
