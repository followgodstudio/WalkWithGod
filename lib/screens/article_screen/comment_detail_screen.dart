import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/comment.dart' as widget;

import '../../widgets/article_preview.dart';

class CommentDetailScreen extends StatelessWidget {
  static const routeName = '/comment_detail';

  @override
  Widget build(BuildContext context) {
    Map<String, String> parameters =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String _userId = Provider.of<ProfileProvider>(context, listen: false).uid;
    String _articleId = parameters['articleId'];
    String _commentId = parameters['commentId'];
    return FutureBuilder(
        future: Provider.of<CommentsProvider>(context, listen: false)
            .fetchL1CommentByCid(_articleId, _commentId, _userId),
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (asyncSnapshot.error != null)
            return Center(
              child: Text('An error occurred!'),
            );
          return ChangeNotifierProvider(
            create: (_) => asyncSnapshot.data as CommentProvider,
            child: Builder(builder: (BuildContext context) {
              BuildContext rootContext = context;
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text('留言详情',
                        style: Theme.of(context).textTheme.headline2),
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Theme.of(context).buttonColor,
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
                        Provider.of<CommentProvider>(rootContext, listen: false)
                            .fetchMoreL2ChildrenComments(_userId);
                      }
                      return true;
                    },
                    child: SingleChildScrollView(child:
                        Consumer<CommentProvider>(
                            builder: (context, data, child) {
                      List<Widget> list = [];
                      list.add(SizedBox(height: 10.0));
                      list.add(widget.Comment());
                      list.add(ArticlePreview(_articleId));
                      list.add(Divider(
                        color: Color.fromARGB(255, 128, 128, 128),
                      ));
                      if (data.childrenCount == 0) {
                        list.add(Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("暂无回复",
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.captionMedium3),
                        )));
                        return Column(children: list);
                      }
                      for (var i = 0; i < data.children.length; i++) {
                        list.add(ChangeNotifierProvider.value(
                          value: data.children[i],
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: widget.Comment(),
                          ),
                        ));
                      }
                      if (data.noMoreChild) {
                        list.add(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("到底啦",
                              style:
                                  Theme.of(context).textTheme.captionMedium3),
                        ));
                      } else {
                        list.add(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("加载更多",
                              style:
                                  Theme.of(context).textTheme.captionMedium3),
                        ));
                      }
                      return Column(children: list);
                    })),
                  )));
            }),
          );
        });
  }
}
