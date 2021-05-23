import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';

class SearchGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groupsSearchDetails = Provider.of<Posts>(context).posts;
    return ListView.builder(
      itemCount: groupsSearchDetails.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.all(10),
          color: Colors.white,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1, color: Colors.grey.shade400),
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    groupsSearchDetails[index].postImageUrl,
                  ),
                  minRadius: MediaQuery.of(context).size.width * 0.12,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "moaz groups",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.028,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${20} " + "members",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "${20} " + "photos",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "${20} " + "discussions",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
