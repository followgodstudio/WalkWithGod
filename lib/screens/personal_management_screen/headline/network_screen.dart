import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/configurations/constants.dart';
import 'package:walk_with_god/providers/user/friend_provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/friends_provider.dart';
import '../../../providers/user/profile_provider.dart';
import 'introduction.dart';

class NetworkScreen extends StatelessWidget {
  static const routeName = '/network';
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments as String;
    final ProfileProvider curProfile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).textTheme.buttonColor2,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
        body: SafeArea(
            child: FutureBuilder(
                future: Provider.of<ProfileProvider>(context, listen: false)
                    .fetchProfileByUid(uid),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (asyncSnapshot.error != null)
                    return Center(child: Text('An error occurred!'));
                  ProfileProvider profile = asyncSnapshot.data;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: <Widget>[
                        Introduction(profile.name, profile.imageUrl),
                        if (uid != curProfile.uid)
                          FriendStatus(curProfile, profile),
                        Divider(color: Color.fromARGB(255, 128, 128, 128)),
                      ]),
                    ),
                  );
                })));
  }
}

class FriendStatus extends StatelessWidget {
  final ProfileProvider curProfile;
  final ProfileProvider profile;
  FriendStatus(this.curProfile, this.profile);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<FriendsProvider>(context, listen: false)
            .fetchFriendStatusByUid(curProfile.uid, profile.uid),
        builder: (ctx, AsyncSnapshot<FriendProvider> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (asyncSnapshot.error != null)
            return Center(child: Text('An error occurred!'));
          return ChangeNotifierProvider.value(
              value: (asyncSnapshot.data != null)
                  ? asyncSnapshot.data
                  : FriendProvider(
                      uid: curProfile.uid,
                      name: curProfile.name,
                      imageUrl: curProfile.imageUrl,
                      friendUid: profile.uid,
                      friendName: profile.name,
                      friendImageUrl: profile.imageUrl),
              child: Consumer<FriendProvider>(
                builder: (context, friend, child) {
                  String buttonText = "开始关注";
                  bool isFollowing = false;
                  if (friend.friendStatus == eFriendStatusFollowing) {
                    buttonText = "已关注";
                    isFollowing = true;
                  }
                  if (friend.friendStatus == eFriendStatusFriend) {
                    buttonText = "已互相关注";
                    isFollowing = true;
                  }
                  return FlatButton(
                      onPressed: () {
                        if (isFollowing) {
                          friend.unfollow();
                        } else {
                          friend.follow();
                        }
                      },
                      child: Text(buttonText,
                          style: isFollowing
                              ? Theme.of(context).textTheme.bodyText2
                              : Theme.of(context).textTheme.bodyTextWhite),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: isFollowing
                          ? Theme.of(context).buttonColor
                          : Colors.blue);
                },
              ));
        });
  }
}
