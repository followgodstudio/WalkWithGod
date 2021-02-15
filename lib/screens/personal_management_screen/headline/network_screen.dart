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
import '../../../widgets/article_card.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';
import 'introduction.dart';

class NetworkScreen extends StatelessWidget {
  static const routeName = '/network';
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments as String;
    final ProfileProvider myProfile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: NavBar(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
                            await profile.recentReadProvider.fetchRecentRead();
                            return [isUserExist, friend];
                          }),
                          builder: (ctx, asyncSnapshot) {
                            if (asyncSnapshot.connectionState ==
                                    ConnectionState.waiting ||
                                asyncSnapshot.data == null)
                              return MyProgressIndicator();
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
                                  SizedBox(height: 10.0),
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
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: MyTextButton(
          width: 120,
          text: buttonText,
          style: isFollowing ? TextButtonStyle.regular : TextButtonStyle.active,
          onPressed: () {
            if (isFollowing) {
              friend.unfollow(myProfile.uid);
              friends.removefollowInList(profile.uid);
            } else {
              friend.follow(myProfile.uid);
              friends.addFollowInList(friend);
            }
          },
        ),
      );
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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Divider(),
              SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text("已完成",
                          style: Theme.of(context).textTheme.captionMedium1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                            profile.recentReadProvider.readsCount.toString(),
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Text("篇文章",
                          style: Theme.of(context).textTheme.captionMedium2)
                    ]),
                    Column(children: [
                      Text("已阅读",
                          style: Theme.of(context).textTheme.captionMedium1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                            profile.recentReadProvider.readDuration.toString(),
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Text("个小时",
                          style: Theme.of(context).textTheme.captionMedium2)
                    ]),
                    Column(children: [
                      Text("共有",
                          style: Theme.of(context).textTheme.captionMedium1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                            profile.friendsProvider.followersCount.toString(),
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Text("人关注",
                          style: Theme.of(context).textTheme.captionMedium2)
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(),
              ),
            ],
          ),
        ),
        Consumer<FriendProvider>(builder: (context, friend, child) {
          bool showRecentRead = profile.uid == myProfile.uid ||
              (!profile.settingProvider.hideRecentRead &&
                  (friend.friendStatus == eFriendStatusFollowing ||
                      friend.friendStatus == eFriendStatusFriend));
          if (!showRecentRead) return SizedBox();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Consumer<RecentReadProvider>(
              builder: (context, recentRead, child) => Column(children: [
                Text("最近一周阅读",
                    style: Theme.of(context).textTheme.captionMedium1),
                SizedBox(height: 8.0),
                Text(
                    "共" +
                        recentRead.recentReadStringList.length.toString() +
                        "篇文章",
                    style: Theme.of(context).textTheme.captionGrey),
                if (recentRead.readsCount > 0)
                  Container(
                    height: 220,
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            exceptionHandling(context, () async {
                              await recentRead.fetchMoreRecentRead();
                            });
                          }
                          return true;
                        },
                        child: ListView(children: [
                          SizedBox(width: horizontalPadding),
                          ...recentRead.recentRead
                              .map((element) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 12.5, bottom: 30),
                                    child: ArticleCard(article: element),
                                  ))
                              .toList(),
                          if (!recentRead.noMoreRecentRead &&
                              recentRead.recentRead.length != 0)
                            Center(child: Icon(Icons.more_horiz)),
                          SizedBox(width: horizontalPadding - 10.0),
                        ], scrollDirection: Axis.horizontal)),
                  ),
              ]),
            ),
          );
        })
      ],
    );
  }
}
