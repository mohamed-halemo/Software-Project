import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';
import '../providers/flickr_post.dart';
import '../screens/non_profile_screen.dart';
import '../providers/flickr_profiles.dart';

/// Contains list of the people profiles that came from the search result.
class SearchPeople extends StatefulWidget {
  final peopleSearchResult;
  SearchPeople(this.peopleSearchResult);
  @override
  _SearchPeopleState createState() => _SearchPeopleState();
}

class _SearchPeopleState extends State<SearchPeople> {
  void _goToNonprofile(BuildContext ctx, PostDetails postInformation,
      List<PostDetails> currentPosts, FlickrProfiles flickrProfiles) {
    final flickrProfileDetails = flickrProfiles.addProfileDetailsToList(
        postInformation.picPoster, currentPosts);
    /* final flickrProfileDetails = FlickrProfiles().profiles.where(
        (profile) => profile.profileID == postInformation.picPoster.profileId); */
    print(flickrProfileDetails.profileID);
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: [postInformation, flickrProfileDetails],
    );
  }

  void toggleFollowPicPoster(
      PicPosterDetails personDetails, List<PostDetails> currentPosts) {
    final profileFirstPostFound = currentPosts.firstWhere(
        (post) => post.picPoster.profileId == personDetails.profileId);
    profileFirstPostFound.toggleFollowPicPoster(currentPosts, personDetails);
  }

  @override
  Widget build(BuildContext context) {
    /// Contains the list of the photos that came from the search result if any.
    final peopleSearchDetails =
        widget.peopleSearchResult as List<PicPosterDetails>;
    final flickrProfiles = Provider.of<FlickrProfiles>(context);
    final currentPosts = Provider.of<Posts>(context).posts;
    return ListView.builder(
      itemCount: peopleSearchDetails.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: peopleSearchDetails[index],
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                _goToNonprofile(
                    context, currentPosts[index], currentPosts, flickrProfiles);
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 20,
                backgroundImage: NetworkImage(
                  peopleSearchDetails[index].profilePicUrl,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            title: Text(
              peopleSearchDetails[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "${500}" + " photos - " + "${500}" + " followers",
              overflow: TextOverflow.fade,
              softWrap: true,
            ),
            trailing: FlatButton(
              shape: Border.all(
                color: Colors.black,
                width: 2,
              ),
              color: Colors.transparent,
              onPressed: () {
                setState(() {
                  toggleFollowPicPoster(
                      peopleSearchDetails[index], currentPosts);
                  /* peopleSearchDetails[index]
                        .toggleFollowPicPoster(currentPosts); */
                });
              },
              child: peopleSearchDetails[index].isFollowedByUser
                  ? Icon(Icons.beenhere_outlined)
                  : Text("+" + " Follow"),
            ),
          ),
        );
      },
    );
  }
}
