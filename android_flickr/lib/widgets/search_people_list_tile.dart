import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';
import '../providers/flickr_post.dart';
import '../screens/non_profile_screen.dart';
import '../providers/flickr_profiles.dart';

class SearchPeopleListTile extends StatefulWidget {
  //const SearchPeopleListTile({ Key? key }) : super(key: key);
/*   final personSearchResult;

  SearchPeopleListTile(this.personSearchResult); */

  @override
  _SearchPeopleListTileState createState() => _SearchPeopleListTileState();
}

class _SearchPeopleListTileState extends State<SearchPeopleListTile> {
  /// When circle avatar or name is pressed then the app navigates to this user and sends its details(post information) and other posts
  /// and profiles to choose the posts and images needed and display them.
  void _goToNonprofile(BuildContext ctx, PicPosterDetails userDetails,
      List<PostDetails> currentPosts, FlickrProfiles flickrProfiles) {
    final flickrProfileDetails =
        flickrProfiles.addProfileDetailsToList(userDetails, currentPosts);
    /* final flickrProfileDetails = FlickrProfiles().profiles.where(
        (profile) => profile.profileID == postInformation.picPoster.profileId); */
    // print(flickrProfileDetails.profileID);
    final profileFirstPostFound = currentPosts.firstWhere(
      (post) => post.picPoster.profileId == userDetails.profileId,
      orElse: () {
        return PostDetails(
          picPoster: userDetails,
          id: "-1",
          dateTaken: DateTime.now(),
          privacy: false,
          description: "",
          tags: [],
          commentsTotalNumber: 20,
          postImageUrl: "postImageUrl",
          postedSince: "6w",
          favesDetails: FavedPostDetails(favedUsersNames: [], isFaved: false),
        );
      },
    );
    Navigator.of(ctx).pushNamed(
      NonProfileScreen.routeName,
      arguments: [profileFirstPostFound, flickrProfileDetails],
    );
  }

  ///When the follow button is pressed this function updates the data so any widgets that needs to know can notice the changes
  void toggleFollowPicPoster(
      PicPosterDetails personDetails, List<PostDetails> currentPosts) {
    //print("first");
    //print(personDetails.isFollowedByUser);
    //print
    final profileFirstPostFound = currentPosts.firstWhere(
        (post) => post.picPoster.profileId == personDetails.profileId);
    profileFirstPostFound.toggleFollowPicPoster(
        currentPosts, profileFirstPostFound.picPoster);
    personDetails.notify();
    //print("second");
    //print(personDetails.isFollowedByUser);
    setState(() {
      personDetails.isFollowedByUser = !personDetails.isFollowedByUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final personSearchDetails = widget.personSearchResult as PicPosterDetails;
    final personSearchDetails = Provider.of<PicPosterDetails>(context);
    final flickrProfiles = Provider.of<FlickrProfiles>(context);
    final currentPosts = Provider.of<Posts>(context).posts;
    /*    final personSearchDetails = Provider.of<Posts>(context)
        .posts
        .firstWhere(
            (post) => post.picPoster.profileId == personDetails.profileId)
        .picPoster; */
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          _goToNonprofile(
              context, personSearchDetails, currentPosts, flickrProfiles);
        },
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width / 20,
          backgroundImage: personSearchDetails.profilePicUrl != null
              ? NetworkImage(
                  personSearchDetails.profilePicUrl,
                )
              : AssetImage('assets/images/FlickrDefaultProfilePic.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        personSearchDetails.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${personSearchDetails.photosCount}" +
            " photos - " +
            "${personSearchDetails.followersCount}" +
            " followers",
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
            toggleFollowPicPoster(personSearchDetails, currentPosts);
            /* personSearchDetails
                        .toggleFollowPicPoster(currentPosts); */
          });
        },
        child: personSearchDetails.isFollowedByUser
            ? Icon(Icons.beenhere_outlined)
            : Text("+" + " Follow"),
      ),
    );
  }
}
