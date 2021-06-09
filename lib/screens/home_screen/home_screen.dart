import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../screens/personal_management_screen/personal_management_screen.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/my_bottom_indicator.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/navbar.dart';
import '../../widgets/profile_picture.dart';
import 'article_list.dart';

enum PageContent { following, friends, all }

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller = new ScrollController();
  var prevIndex = -1;
  var activePage = PageContent.following;
  ValueNotifier<String> title;
  ValueNotifier<String> formattedDate;
  ValueNotifier<DateTime> curDate;
  var formatter = new DateFormat('MMM yyyy');

  String diff(DateTime time) {
    var now = DateTime.now();
    var diffDays = now.difference(time).inDays;
    if (diffDays < 1) {
      return "今日";
    } else if (diffDays < 2) {
      return "昨日";
    } else if (diffDays < 3) {
      return "前日";
    }
    return "往日";
  }

  @override
  void didChangeDependencies() {
    var articleHeight = (MediaQuery.of(context).size.width - 60) / 5 * 6 + 25;
    title = ValueNotifier<String>("今日");
    formattedDate = ValueNotifier<String>(formatter.format(new DateTime.now()));
    curDate = ValueNotifier<DateTime>(new DateTime.now());
    _controller.addListener(() {
      var index = (_controller.offset.floor() / articleHeight).floor();
      var articles =
          Provider.of<ArticlesProvider>(context, listen: false).articles;
      if (index != prevIndex && index < articles.length && index >= 0) {
        title.value = diff(articles[index].createdDate);
        formattedDate.value = formatter.format(articles[index].createdDate);
        curDate.value = articles[index].createdDate;
        prevIndex = index;
      }
    });
    super.didChangeDependencies();
  }

  refreshHeader(articles) {
    if (articles.length < 1) {
      return;
    }
    title = ValueNotifier<String>(diff(articles[0].createdDate));
    formattedDate =
        ValueNotifier<String>(formatter.format(articles[0].createdDate));
    curDate = ValueNotifier<DateTime>(articles[0].createdDate);
  }

  Future<void> refreshArticles() async {
    await exceptionHandling(context, () async {
      await Provider.of<ArticlesProvider>(context, listen: false)
          .fetchArticlesByDate();
    });
  }

  void activePageChange(PageContent newActivePage) {
    setState(() {
      activePage = newActivePage;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("HomeScreen-build");
    exceptionHandling(context, () async {
      await Provider.of<ProfileProvider>(context, listen: false)
          .fetchAllUserData();
    });
    return Scaffold(
        body: SafeArea(
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    exceptionHandling(context, () async {
                      await Provider.of<ArticlesProvider>(context,
                              listen: false)
                          .fetchMoreArticles(new DateTime.utc(1989, 11, 9));
                    });
                  }
                  return true;
                },
                child: RefreshIndicator(
                    onRefresh: refreshArticles,
                    child: Consumer<ArticlesProvider>(
                        builder: (context, articles, child) {
                      refreshHeader(articles.articles);
                      return CustomScrollView(
                          controller: _controller,
                          slivers: [
                            NavBar(
                                hasBackButton: false,
                                isSliverAppBar: true,
                                toolbarHeight: 80.0,
                                expandedHeight: 120.0,
                                flexibleSpace:
                                    PageNavigator(activePage, activePageChange),
                                titleWidget: Row(
                                  children: [
                                    SizedBox(width: 15),
                                    ValueListenableBuilder(
                                      valueListenable: curDate,
                                      builder:
                                          (context, DateTime value, child) =>
                                              Text(
                                        value.day.toString().padLeft(2, '0'),
                                        style: (DateTime.now()
                                                    .difference(value)
                                                    .inDays <
                                                1)
                                            ? Theme.of(context)
                                                .textTheme
                                                .dateLarge
                                            : Theme.of(context)
                                                .textTheme
                                                .dateLarge
                                                .copyWith(
                                                    color: MyColors.midGrey),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable: title,
                                            builder: (context, String value,
                                                    child) =>
                                                Text(
                                              value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .curDaySmall,
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: formattedDate,
                                            builder: (context, String value,
                                                    child) =>
                                                Text(
                                              value.toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .dateSmall,
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                                actionButton: FlatButton(
                                  child: Consumer<ProfileProvider>(
                                      builder: (ctx, profile, _) =>
                                          ProfilePicture(
                                              18.0, profile.imageUrl)),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      PersonalManagementScreen.routeName,
                                    );
                                  },
                                )),
                            ArticleList(),
                            SliverToBoxAdapter(
                                child: MyBottomIndicator(articles.noMoreChild)),
                          ]);
                    })))));
  }
}

class PageNavigator extends StatefulWidget {
  final PageContent activePage;
  final Function activePageChanged;
  PageNavigator(this.activePage, this.activePageChanged);

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  double leftPosition = 0;
  GlobalKey _keyFollowing = GlobalKey();
  GlobalKey _keyFriends = GlobalKey();
  GlobalKey _keyAll = GlobalKey();

  void changePosition(GlobalKey key) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);
    setState(() {
      leftPosition = position.dx - 30.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 75.0, left: 30.0, right: 30.0),
        child: Container(
          width: 100,
          height: 100,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    PageNavigatorButton(_keyFollowing, "我的关注",
                        widget.activePage == PageContent.following, () {
                      widget.activePageChanged(PageContent.following);
                      changePosition(_keyFollowing);
                    }),
                    PageNavigatorButton(_keyFriends, "好友喜欢",
                        widget.activePage == PageContent.friends, () {
                      widget.activePageChanged(PageContent.friends);
                      changePosition(_keyFriends);
                    }),
                    PageNavigatorButton(
                        _keyAll, "全部更新", widget.activePage == PageContent.all,
                        () {
                      widget.activePageChanged(PageContent.all);
                      changePosition(_keyAll);
                    }),
                  ]),
                  MyIconButton(
                      hasBorder: true, icon: 'search', onPressed: () {}),
                ],
              ),
              Container(
                height: 4.0,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                        left: leftPosition,
                        duration: Duration(milliseconds: 100),
                        child: Container(
                            width: 40, height: 4.0, color: MyColors.yellow)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class PageNavigatorButton extends StatelessWidget {
  final GlobalKey key;
  final String buttonText;
  final bool isActive;
  final Function onPressed;
  PageNavigatorButton(this.key, this.buttonText, this.isActive, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.only(right: 10),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: Text(
          buttonText,
          style: isActive
              ? Theme.of(context).textTheme.captionMedium1
              : Theme.of(context)
                  .textTheme
                  .captionMedium1
                  .copyWith(color: MyColors.midGrey),
        ),
        onPressed: onPressed);
  }
}
