import 'package:android_flickr/models/flickr_groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';

/// Contains list of the groups that came from the search result.
class SearchGroups extends StatelessWidget {
  List<FlickrGroup> groupsSearchResult;
  SearchGroups(this.groupsSearchResult);
  @override
  Widget build(BuildContext context) {
    /// Contains the list of the groups that came from the search result if any.
    final groupsSearchDetails = groupsSearchResult;
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
                  backgroundImage:
                      AssetImage('assets/images/FlickrDefaultProfilePic.jpg'
                          //groupsSearchDetails[index].postImageUrl,
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
                      groupsSearchDetails[index].groupName,
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
                      "${groupsSearchDetails[index].memberCount} " + "members",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "${groupsSearchDetails[index].photoCount} " + "photos",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "${groupsSearchDetails[index].discussionCount} " +
                          "discussions",
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
