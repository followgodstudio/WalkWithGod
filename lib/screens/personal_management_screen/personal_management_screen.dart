import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user/friends_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../providers/user/saved_articles_provider.dart';
import '../../widgets/article_card_small.dart';
import '../../widgets/popup_dialog.dart';
import '../auth_screen/signup_screen.dart';
import 'friends/friends_list_screen.dart';
import 'headline/edit_profile_screen.dart';
import 'headline/introduction.dart';
import 'headline/network_screen.dart';
import 'messages/messages_list_screen.dart';
import 'saved_articles/saved_articles_screen.dart';
import 'setting/setting_screen.dart';

class PersonalManagementScreen extends StatelessWidget {
  static const routeName = '/personal_management';
  @override
  Widget build(BuildContext context) {
    print("PersonalManagementScreen");
    String uid = Provider.of<AuthProvider>(context, listen: false).currentUser;
    bool isLoggedIn = (uid != null);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('我的', style: Theme.of(context).textTheme.captionMedium2),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).textTheme.buttonColor2,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).textTheme.buttonColor2,
              onPressed: () {
                if (!isLoggedIn) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                        return PopUpDialog(false, "请登陆后再操作");
                      });
                } else {
                  Navigator.of(context).pushNamed(SettingScreen.routeName);
                }
              },
            ),
          ],
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              HeadLine(isLoggedIn),
              SizedBox(height: 15),
              if (isLoggedIn) SavedArticles(),
              if (isLoggedIn) FriendsMessages(),
            ]),
          ),
        )));
  }
}

class HeadLine extends StatelessWidget {
  final bool isLoggedIn;
  HeadLine(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              NetworkScreen.routeName,
              arguments:
                  Provider.of<ProfileProvider>(context, listen: false).uid,
            );
          },
          child: Column(
            children: [
              Consumer<ProfileProvider>(
                  builder: (ctx, profile, _) =>
                      Introduction("你好，" + profile.name, profile.imageUrl)),
              SizedBox(height: 8.0),
              FlatButton(
                  onPressed: () {
                    if (isLoggedIn) {
                      Navigator.of(context)
                          .pushNamed(EditProfileScreen.routeName);
                    } else {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    }
                  },
                  child: Text(isLoggedIn ? "编辑个人资料" : "请登陆 / 注册",
                      style: Theme.of(context).textTheme.captionSmall2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context).buttonColor),
            ],
          )),
    );
  }
}

class SavedArticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedArticlesProvider>(builder: (context, saved, child) {
      Widget savedArticles;
      if (saved.articles.length == 0) {
        savedArticles = SizedBox(height: 8.0);
      } else {
        List<Widget> list = [];
        saved.articles.forEach((element) {
          list.add(ArticleCard(element, 4 / 5));
        });
        if (!saved.noMore) list.add(Center(child: Icon(Icons.more_horiz)));
        savedArticles = Container(
          height: 200,
          child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  saved.fetchMoreSavedArticles();
                }
                return true;
              },
              child:
                  ListView(children: list, scrollDirection: Axis.horizontal)),
        );
      }
      return Column(children: [
        Divider(),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text("我的收藏",
                      style: Theme.of(context).textTheme.captionMedium1),
                  SizedBox(height: 8.0),
                  Text("共" + saved.savedArticlesCount.toString() + "篇收藏",
                      style: Theme.of(context).textTheme.captionMain),
                ],
              ),
            ),
            if (saved.articles.length > 0)
              FlatButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(SavedArticlesScreen.routeName);
                  },
                  child: Text("查看全部",
                      style: Theme.of(context).textTheme.captionSmall2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context).buttonColor),
          ],
        ),
        savedArticles,
      ]);
    });
  }
}

class FriendsMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<ProfileProvider>(context, listen: false)
            .fetchProfileStream(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          return Column(
            children: [
              Divider(),
              FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pushNamed(FriendsListScreen.routeName);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "我的好友",
                              style: Theme.of(context).textTheme.captionMedium1,
                            ),
                            SizedBox(height: 8.0),
                            Consumer<FriendsProvider>(
                                builder: (ctx, value, _) => Text(
                                      "共" +
                                          (snapshot.data[fUserFollowersCount] ==
                                                  null
                                              ? 0
                                              : snapshot
                                                  .data[fUserFollowersCount]
                                                  .toString()) +
                                          "人关注我, 已关注" +
                                          value.followingsCount.toString() +
                                          "人",
                                      style: Theme.of(context)
                                          .textTheme
                                          .captionSmall2,
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 20.0, color: Color.fromARGB(255, 128, 128, 128)),
                  ],
                ),
              ),
              Divider(),
              FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pushNamed(MessagesListScreen.routeName);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "我的消息",
                              style: Theme.of(context).textTheme.captionMedium1,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "共" +
                                  snapshot.data[fUserMessagesCount].toString() +
                                  "条消息, " +
                                  snapshot.data[fUserUnreadMsgCount]
                                      .toString() +
                                  "条未读",
                              style: Theme.of(context).textTheme.captionSmall2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 20.0, color: Color.fromARGB(255, 128, 128, 128)),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        });
  }
}
