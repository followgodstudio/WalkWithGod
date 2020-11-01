import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/user/friends_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../providers/user/saved_articles_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/article_card.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_progress_indicator.dart';
import '../../widgets/my_text_button.dart';
import '../../widgets/navbar.dart';
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
    MyLogger("Widget").i("PersonalManagementScreen-build");
    bool isLoggedIn =
        (Provider.of<ProfileProvider>(context, listen: false).uid != null);
    return Scaffold(
        appBar: NavBar(
            title: "我的",
            actionButton: MyIconButton(
                icon: "setting",
                onPressed: () {
                  if (!isLoggedIn) {
                    showPopUpDialog(context, false, "请登录后再操作");
                  } else {
                    Navigator.of(context).pushNamed(SettingScreen.routeName);
                  }
                })),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(children: <Widget>[
              HeadLine(isLoggedIn),
              SizedBox(height: 15),
              if (isLoggedIn) SavedArticles(),
              if (isLoggedIn)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: FriendsMessages(),
                ),
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
              SizedBox(height: 10.0),
              MyTextButton(
                width: 100,
                text: isLoggedIn ? "编辑个人资料" : "请登录 / 注册",
                isSmall: true,
                onPressed: () {
                  if (isLoggedIn) {
                    Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName);
                  } else {
                    Navigator.of(context).pushNamed(SignupScreen.routeName);
                  }
                },
              ),
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
        List<Widget> list = [SizedBox(width: horizontalPadding)];
        saved.articles.forEach((element) {
          list.add(Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 12.5, bottom: 20),
            child: ArticleCard(article: element),
          ));
        });
        if (!saved.noMore) list.add(Center(child: Icon(Icons.more_horiz)));
        list.add(SizedBox(width: horizontalPadding - 10.0));
        savedArticles = Container(
          height: 210,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
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
                            style: Theme.of(context).textTheme.captionGrey),
                      ],
                    ),
                  ),
                  if (saved.articles.length > 0)
                    MyTextButton(
                      text: "查看全部",
                      isSmall: true,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SavedArticlesScreen.routeName);
                      },
                    ),
                ],
              ),
            ],
          ),
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
              snapshot.data == null) return MyProgressIndicator();
          return Column(
            children: [
              MyDivider(),
              SizedBox(height: 5.0),
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
                                          .captionGrey,
                                    )),
                          ],
                        ),
                      ),
                    ),
                    MyIconButton(icon: "forward", iconSize: 12),
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
                              style: Theme.of(context).textTheme.captionGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyIconButton(icon: "forward", iconSize: 12),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        });
  }
}
