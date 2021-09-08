import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/user/friends_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../providers/user/saved_articles_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/article_card.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_text_button.dart';
import '../../widgets/navbar.dart';
import '../../widgets/popup_login.dart';
import '../../widgets/profile_picture.dart';
import '../auth_screen/signup_screen.dart';
import 'friends/friends_list_screen.dart';
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
            actionButton: Row(children: [
              MyIconButton(
                icon: "email",
                onPressed: () {
                  if (!isLoggedIn) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => PopupLogin(),
                    );
                  } else {
                    Navigator.of(context)
                        .pushNamed(MessagesListScreen.routeName);
                  }
                },
              ),
              SizedBox(width: 10),
              MyIconButton(
                  icon: "setting",
                  onPressed: () {
                    if (!isLoggedIn) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PopupLogin(),
                      );
                    } else {
                      Navigator.of(context).pushNamed(SettingScreen.routeName);
                    }
                  })
            ])),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            refreshProfile(context);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Column(children: <Widget>[
                HeadLine(isLoggedIn),
                if (isLoggedIn) SavedArticles(),
              ]),
            ),
          ),
        )));
  }

  Future<void> refreshProfile(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
  }
}

class HeadLine extends StatelessWidget {
  final bool isLoggedIn;
  HeadLine(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Consumer<ProfileProvider>(
            builder: (ctx, profile, _) => Row(
                  children: [
                    ProfilePicture(30.0, profile.imageUrl),
                    SizedBox(width: 20),
                    Text(
                      "你好，" +
                          ((profile.name == null || profile.name.isEmpty)
                              ? defaultUserName
                              : profile.name),
                      style: Theme.of(context).textTheme.buttonLarge,
                    ),
                  ],
                )),
        SizedBox(height: 20.0),
        Consumer<FriendsProvider>(
          builder: (ctx, friends, _) => Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FriendsListScreen.routeName,
                        arguments: true);
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          friends.followersCount.toString(),
                          style: Theme.of(context).textTheme.friendsCount,
                        ),
                        SizedBox(width: 3),
                        Text(
                          '关注了你',
                          style: Theme.of(context).textTheme.captionGrey,
                        )
                      ])),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                    height: 24, child: VerticalDivider(color: MyColors.grey)),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(FriendsListScreen.routeName);
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          friends.followingsCount.toString(),
                          style: Theme.of(context).textTheme.friendsCount,
                        ),
                        SizedBox(width: 3),
                        Text(
                          '被你关注',
                          style: Theme.of(context).textTheme.captionGrey,
                        )
                      ])),
              Expanded(child: SizedBox()),
              MyTextButton(
                width: 120,
                text: isLoggedIn ? "我的个人页" : "请登录 / 注册",
                isSmall: false,
                onPressed: () {
                  if (isLoggedIn) {
                    Navigator.of(context).pushNamed(
                      NetworkScreen.routeName,
                      arguments:
                          Provider.of<ProfileProvider>(context, listen: false)
                              .uid,
                    );
                  } else {
                    Navigator.of(context).pushNamed(SignupScreen.routeName);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SavedArticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedArticlesProvider>(builder: (context, saved, child) {
      Widget savedArticles;
      TextStyle seeAllLikedStyle = Theme.of(context).textTheme.captionMedium1;
      double panelPadding = 15;
      double cardMargin = 10;
      if (saved.articles.length == 0) {
        seeAllLikedStyle = seeAllLikedStyle.copyWith(color: MyColors.midGrey);
        savedArticles = SizedBox(height: 8.0);
      } else {
        List<Widget> list = [SizedBox(width: panelPadding)];
        saved.articles.forEach((element) {
          list.add(Padding(
            padding: EdgeInsets.only(right: cardMargin, top: 20, bottom: 30),
            child: ArticleCard(article: element),
          ));
        });
        if (!saved.noMore) list.add(Center(child: Icon(Icons.more_horiz)));
        list.add(SizedBox(width: panelPadding - cardMargin));
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
      Widget seeAllLiked = Row(
        children: [
          Text("查看全部点赞", style: seeAllLikedStyle),
          SvgPicture.asset('assets/icons/forward.svg',
              width: 15, height: 15, color: MyColors.grey)
        ],
      );
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          color: MyColors.silver,
          child: Column(children: [
            SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  VerticalDivider(
                    indent: 4,
                    thickness: 6,
                    color: MyColors.yellow,
                    width: 0,
                  ),
                  SizedBox(width: panelPadding),
                  Text("我的点赞", style: Theme.of(context).textTheme.buttonLarge),
                ],
              ),
            ),
            MyDivider(
                padding: EdgeInsets.only(
                    top: panelPadding,
                    right: panelPadding,
                    left: panelPadding)),
            savedArticles,
            if (saved.articles.length > 0)
              MyDivider(
                  padding: EdgeInsets.only(
                      bottom: panelPadding,
                      right: panelPadding,
                      left: panelPadding)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: panelPadding),
              child: Row(
                children: [
                  Text("共点赞", style: Theme.of(context).textTheme.captionGrey),
                  SizedBox(width: 3),
                  Text(saved.savedArticlesCount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .friendsCount
                          .copyWith(fontSize: 28, height: 1.1)),
                  SizedBox(width: 3),
                  Text("篇文章", style: Theme.of(context).textTheme.captionGrey),
                  Expanded(child: SizedBox()),
                  if (saved.articles.length > 0)
                    TextButton(
                      child: seeAllLiked,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SavedArticlesScreen.routeName);
                      },
                    ),
                  if (saved.articles.length == 0) seeAllLiked
                ],
              ),
            ),
            SizedBox(height: 20)
          ]),
        ),
      );
    });
  }
}
