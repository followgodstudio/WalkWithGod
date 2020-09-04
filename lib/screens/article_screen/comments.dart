import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../screens/article_screen/comment_detail_screen.dart';
import '../../widgets/comment.dart' as widget;

class Comments extends StatelessWidget {
  final String articleId;
  Comments({
    @required this.articleId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: FutureBuilder(
            future: Provider.of<CommentsProvider>(context, listen: false)
                .fetchL1CommentListByAid(articleId, profile.uid),
            builder: (ctx, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (asyncSnapshot.error != null)
                return Center(
                  child: Text('An error occurred!'),
                );
              return Consumer<CommentsProvider>(
                  builder: (context, data, child) {
                List<CommentProvider> comments = data.items;
                List<Widget> list = [];
                list.add(Divider(
                  color: Color.fromARGB(255, 128, 128, 128),
                ));
                if (comments.length == 0) {
                  list.add(Center(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("暂无评论",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.captionMedium3),
                  )));
                  return Column(children: list);
                }
                for (var i = 0; i < comments.length; i++) {
                  list.add(ChangeNotifierProvider.value(
                    value: comments[i],
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            CommentDetailScreen.routeName,
                            arguments: {
                              "articleId": articleId,
                              "commentId": comments[i].id
                            },
                          );
                        },
                        child: widget.Comment()),
                  ));
                }
                if (data.noMore) {
                  list.add(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("到底啦",
                        style: Theme.of(context).textTheme.captionMedium3),
                  ));
                } else {
                  list.add(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("加载更多",
                        style: Theme.of(context).textTheme.captionMedium3),
                  ));
                }
                return Column(children: list);
              });
            }),
      ),
    );
  }
}
