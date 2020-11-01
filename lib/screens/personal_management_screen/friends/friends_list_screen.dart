import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../providers/user/friends_provider.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/navbar.dart';
import 'friend_item.dart';

// TODO: add wechat and facebook friends, add friends search
class FriendsListScreen extends StatefulWidget {
  static const routeName = '/friends_list';

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  bool _isFollower = false;
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: NavBar(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    if (!_isFollower) return;
                    setState(() {
                      _isFollower = false;
                    });
                  },
                  child: Text('我关注的',
                      style: _isFollower
                          ? Theme.of(context)
                              .textTheme
                              .buttonLarge
                              .copyWith(color: MyColors.grey)
                          : Theme.of(context).textTheme.buttonLarge)),
              SizedBox(width: 20.0),
              GestureDetector(
                  onTap: () {
                    if (_isFollower) return;
                    setState(() {
                      _isFollower = true;
                    });
                  },
                  child: Text('关注我的',
                      style: _isFollower
                          ? Theme.of(context).textTheme.buttonLarge
                          : Theme.of(context)
                              .textTheme
                              .buttonLarge
                              .copyWith(color: MyColors.grey))),
            ],
          ),
        ),
        body: SafeArea(
            child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              exceptionHandling(context, () async {
                await Provider.of<FriendsProvider>(context, listen: false)
                    .fetchMoreFriends(_isFollower);
              });
            }
            return true;
          },
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: FutureBuilder(
                future: exceptionHandling(context, () async {
                  _isFollower
                      ? profile.friendsProvider
                          .fetchFriendList(_isFollower, profile.followersCount)
                      : profile.friendsProvider.refreshFollowingList();
                }),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return MyProgressIndicator();
                  return Consumer<FriendsProvider>(
                      builder: (context, data, child) {
                    List<Widget> list = [];
                    List<FriendProvider> items =
                        _isFollower ? data.follower : data.following;
                    if (items.length == 0) {
                      list.add(Center(
                        child: Text(_isFollower ? "还没有人关注你" : "你还没有关注的人",
                            style: Theme.of(context).textTheme.captionMedium2),
                      ));
                      return Column(children: list);
                    }
                    for (var i = 0; i < items.length; i++) {
                      list.add(ChangeNotifierProvider.value(
                        value: items[i],
                        child: FriendItem(),
                      ));
                    }
                    list.add(Divider());
                    list.add(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          _isFollower
                              ? (data.noMoreFollower ? "到底啦" : "加载更多")
                              : (data.noMoreFollowing ? "到底啦" : "加载更多"),
                          style: Theme.of(context).textTheme.captionMedium2),
                    ));
                    return Column(children: list);
                  });
                }),
          )),
        )));
  }
}
