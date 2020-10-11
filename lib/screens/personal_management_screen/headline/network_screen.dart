import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../providers/user/friends_provider.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../providers/user/recent_read_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/article_card_small.dart';
import 'introduction.dart';

class NetworkScreen extends StatelessWidget {
  static const routeName = '/network';
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments as String;
    final ProfileProvider myProfile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
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
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Builder(builder: (BuildContext context) {
                      ProfileProvider profile = ProfileProvider(uid);
                      FriendsProvider friends =
                          Provider.of<ProfileProvider>(context, listen: false)
                              .friendsProvider;
                      return FutureBuilder(
                          future: exceptionHandling(context, () async {
                            bool isUserExist = await profile.fetchProfile();
                            FriendProvider friend = await friends
                                .fetchFriendStatusByUserId(profile.uid);
                            return [isUserExist, friend];
                          }),
                          builder: (ctx, asyncSnapshot) {
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator());
                            if (!asyncSnapshot.data[0])
                              return Center(child: Text("该用户不存在。"));
                            FriendProvider friend = asyncSnapshot.data[1];
                            return ChangeNotifierProvider.value(
                                value: friend != null
                                    ? friend
                                    : FriendProvider(
                                        friendUid: profile.uid,
                                        friendName: profile.name,
                                        friendImageUrl: profile.imageUrl),
                                child: Column(children: <Widget>[
                                  Introduction(profile.name, profile.imageUrl),
                                  if (uid != myProfile.uid)
                                    FriendStatus(myProfile, profile),
                                  ReadStatus(myProfile, profile),
                                ]));
                          });
                    })))));
  }
}

class FriendStatus extends StatelessWidget {
  final ProfileProvider myProfile;
  final ProfileProvider profile;
  FriendStatus(this.myProfile, this.profile);
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(builder: (context, friend, child) {
      FriendsProvider friends =
          Provider.of<ProfileProvider>(context, listen: false).friendsProvider;
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
              friend.unfollow(
                  myProfile.uid, myProfile.name, myProfile.imageUrl);
              friends.removefollowInList(profile.uid);
            } else {
              friend.follow(myProfile.uid, myProfile.name, myProfile.imageUrl);
              friends.addFollowInList(friend);
            }
          },
          child: Text(buttonText,
              style: isFollowing
                  ? Theme.of(context).textTheme.bodyText2
                  : Theme.of(context).textTheme.bodyTextWhite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: isFollowing ? Theme.of(context).buttonColor : Colors.blue);
    });
  }
}

class ReadStatus extends StatelessWidget {
  final ProfileProvider myProfile;
  final ProfileProvider profile;
  ReadStatus(this.myProfile, this.profile);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Text("已完成", style: Theme.of(context).textTheme.bodyText2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(profile.recentReadProvider.readsCount.toString(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Text("篇文章", style: Theme.of(context).textTheme.captionMedium3)
              ]),
              Column(children: [
                Text("已阅读", style: Theme.of(context).textTheme.bodyText2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                      profile.recentReadProvider.readDuration.toString(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Text("个小时", style: Theme.of(context).textTheme.captionMedium3)
              ]),
              Column(children: [
                Text("共有", style: Theme.of(context).textTheme.bodyText2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(profile.followersCount.toString(),
                      style: Theme.of(context).textTheme.headline6),
                ),
                Text("人关注", style: Theme.of(context).textTheme.captionMedium3)
              ]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Divider(),
        ),
        Consumer<FriendProvider>(builder: (context, friend, child) {
          bool showRecentRead = profile.uid == myProfile.uid ||
              (!profile.settingProvider.hideRecentRead &&
                  (friend.friendStatus == eFriendStatusFollowing ||
                      friend.friendStatus == eFriendStatusFriend));
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(children: [
              if (showRecentRead)
                Text("最近一周阅读",
                    style: Theme.of(context).textTheme.captionMedium1),
              SizedBox(height: 8.0),
              if (showRecentRead)
                Text(
                    "共" +
                        profile.recentReadProvider.readsCount.toString() +
                        "篇文章",
                    style: Theme.of(context).textTheme.captionMain),
              if (showRecentRead && profile.recentReadProvider.readsCount > 0)
                Container(
                    height: 200,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          exceptionHandling(context, () async {
                            await profile.recentReadProvider
                                .fetchMoreRecentRead();
                          });
                        }
                        return true;
                      },
                      child: Consumer<RecentReadProvider>(
                          builder: (context, value, child) =>
                              ListView(children: [
                                ...value.recentRead
                                    .map((e) => ArticleCard(e, 4 / 5))
                                    .toList(),
                                if (!value.noMoreRecentRead &&
                                    value.recentRead.length != 0)
                                  Center(child: Icon(Icons.more_horiz))
                              ], scrollDirection: Axis.horizontal)),
                    ))
            ]),
          );
        })
      ],
    );
  }
}
