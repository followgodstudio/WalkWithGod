import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user/recent_read_provider.dart';
import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../utils/utils.dart';
import '../../../widgets/article_widget.dart';
import '../../../widgets/my_bottom_indicator.dart';
import '../../../widgets/navbar.dart';

class RecentReadScreen extends StatelessWidget {
  static const routeName = '/recent_read';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "最近阅读"),
        body: SafeArea(
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            exceptionHandling(context, () async {
              await Provider.of<RecentReadProvider>(context, listen: false)
                  .fetchMoreRecentRead();
            });
          }
          return true;
        }, child: Consumer<RecentReadProvider>(
                    builder: (context, recentRead, child) {
          if (recentRead.recentRead.length == 0)
            return Center(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Text("暂无最近阅读",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.captionMedium2),
              ),
            );
          List<Widget> recentReadWidgets = [];
          for (var article in recentRead.recentRead) {
            recentReadWidgets.add(ArticleWidget(article));
          }
          recentReadWidgets.add(MyBottomIndicator(recentRead.noMoreRecentRead));
          return SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(children: recentReadWidgets),
          ));
        }))));
  }
}
