import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/comment.dart';
import 'comment_detail.dart';

class Comments extends StatefulWidget {
  final String articleId;
  final String commentId;
  Comments({
    @required this.articleId,
    this.commentId,
    Key key,
  }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If this page comes from the message list, pop up comment detail. call once
      if (widget.commentId != null) {
        showMaterialModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (context, scrollController) => CommentDetail(
                articleId: widget.articleId, commentId: widget.commentId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return FutureBuilder(
        future: Provider.of<CommentsProvider>(context, listen: false)
            .fetchL1CommentListByAid(widget.articleId, profile.uid),
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (asyncSnapshot.error != null)
            return Center(child: Text('An error occurred!'));
          return Consumer<CommentsProvider>(builder: (context, data, child) {
            List<CommentProvider> comments = data.items;
            List<Widget> list = [];
            list.add(Divider(
              indent: 15.0,
              endIndent: 15.0,
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
                      showMaterialModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          context: context,
                          builder: (context, scrollController) => CommentDetail(
                              articleId: widget.articleId,
                              commentId: comments[i].id));
                    },
                    child: Comment()),
              ));
            }
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data.noMore ? "到底啦" : "加载更多",
                  style: Theme.of(context).textTheme.captionMedium3),
            ));
            return Column(children: list);
          });
        });
  }
}
