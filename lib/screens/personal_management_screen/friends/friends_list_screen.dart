import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../providers/user/friends_provider.dart';
import '../../../providers/user/profile_provider.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: Row(
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
                          ? Theme.of(context).textTheme.buttonLargeGray
                          : Theme.of(context).textTheme.buttonLarge1)),
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
                          ? Theme.of(context).textTheme.buttonLarge1
                          : Theme.of(context).textTheme.buttonLargeGray)),
            ],
          ),
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
            child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              Provider.of<FriendsProvider>(context, listen: false)
                  .fetchMoreFriends(_isFollower);
            }
            return true;
          },
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
                future: _isFollower
                    ? profile.friendsProvider
                        .fetchFriendList(_isFollower, profile.followersCount)
                    : profile.friendsProvider.refreshFollowingList(),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (asyncSnapshot.error != null)
                    return Center(child: Text('An error occurred!'));
                  return Consumer<FriendsProvider>(
                      builder: (context, data, child) {
                    List<Widget> list = [];
                    List<FriendProvider> items =
                        _isFollower ? data.follower : data.following;
                    if (items.length == 0) {
                      list.add(Center(
                        child: Text(_isFollower ? "还没有人关注你" : "你还没有关注的人",
                            style: Theme.of(context).textTheme.captionMedium3),
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
                          style: Theme.of(context).textTheme.captionMedium3),
                    ));
                    return Column(children: list);
                  });
                }),
          )),
        )));
  }
}
