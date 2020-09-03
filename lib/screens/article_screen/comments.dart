import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
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
        child: Container(
            height: 500,
            child: FutureBuilder(
                future: Provider.of<CommentsProvider>(context, listen: false)
                    .fetchL1CommentListByAid(articleId, profile.uid),
                builder: (ctx, _) =>
                    Consumer<CommentsProvider>(builder: (context, data, child) {
                      List<CommentProvider> comments = data.items;
                      if (comments.length == 0)
                        return Text("暂无评论",
                            style: Theme.of(context).textTheme.captionSmall3);
                      ListView listview = ListView.separated(
                        itemBuilder: (ctx, i) {
                          return ChangeNotifierProvider.value(
                            value: comments[i],
                            child: widget.Comment(),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: comments.length,
                      );
                      Column column = Column(children: [
                        Expanded(child: listview),
                        if (data.noMore)
                          Text("--------评论到底了--------",
                              style: Theme.of(context).textTheme.captionSmall3),
                        if (!data.noMore)
                          FlatButton(
                              child: Text("加载更多...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionSmall3),
                              onPressed: () async {
                                await data.fetchMoreL1Comments(profile.uid);
                              }),
                      ]);
                      //TODO: need to replace by auto load
                      return column;
                    }))),
      ),
    );
  }
}
