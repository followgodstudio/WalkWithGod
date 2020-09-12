import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/comment.dart';

class CommentDetail extends StatelessWidget {
  final String articleId;
  final String commentId;
  CommentDetail({this.articleId, this.commentId});
  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<ProfileProvider>(context, listen: false).uid;
    return Container(
        height: 0.85 * MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: Provider.of<CommentsProvider>(context, listen: false)
                .fetchL1CommentByCid(articleId, commentId, _userId),
            builder: (ctx, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (asyncSnapshot.error != null)
                return Center(child: Text('An error occurred'));
              return ChangeNotifierProvider(
                  create: (_) => asyncSnapshot.data as CommentProvider,
                  child: Builder(builder: (BuildContext context) {
                    BuildContext rootContext = context;
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          Provider.of<CommentProvider>(rootContext,
                                  listen: false)
                              .fetchMoreL2ChildrenComments(_userId);
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Consumer<CommentProvider>(
                            builder: (context, data, child) {
                          List<Widget> list = [];
                          list.add(Comment());
                          if (data.childrenCount == 0) {
                            list.add(Center(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("暂无回复",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium3),
                            )));
                            return Column(children: list);
                          }
                          for (var i = 0; i < data.children.length; i++) {
                            list.add(ChangeNotifierProvider.value(
                              value: data.children[i],
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Comment(),
                              ),
                            ));
                          }
                          list.add(Divider());
                          list.add(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data.noMoreChild ? "到底啦" : "加载更多",
                                style:
                                    Theme.of(context).textTheme.captionMedium3),
                          ));
                          return Column(children: list);
                        }),
                      )),
                    );
                  }));
            }));
  }
}
