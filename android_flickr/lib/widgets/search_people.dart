import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flickr_posts.dart';

class SearchPeople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final peopleSearchDetails = Provider.of<Posts>(context).posts;
    return ListView.builder(
      itemCount: peopleSearchDetails.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: MediaQuery.of(context).size.width / 20,
            backgroundImage: NetworkImage(
              peopleSearchDetails[index].picPoster.profilePicUrl,
            ),
            backgroundColor: Colors.transparent,
            /* child: Image.asset(
                postInformation.url,
                alignment: Alignment.center,
                fit: BoxFit.fill,

                //height: double.infinity,
              ), */
          ),
          title: Text(
            peopleSearchDetails[index].picPoster.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "${500}" + " photos - " + "${500}" + " followers",
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
          trailing: peopleSearchDetails[index].picPoster.isFollowedByUser
              ? FlatButton(
                  shape: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  color: Colors.transparent,
                  onPressed: () {},
                  child: Icon(Icons.beenhere_outlined),
                )
              : FlatButton(
                  shape: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  color: Colors.transparent,
                  onPressed: () {},
                  child: Text("+" + " Follow"),
                ),
        );
      },
    );
  }
}
