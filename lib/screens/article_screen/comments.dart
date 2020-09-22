import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/comment.dart';
import '../../widgets/popup_dialog.dart';
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
  ProfileProvider profile;

  @override
  void initState() {
    super.initState();
    profile = Provider.of<ProfileProvider>(context, listen: false);
    if (widget.commentId != null) {
      // If this page comes from the message list, pop up comment detail. call once
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        CommentProvider commentProvider =
            await Provider.of<CommentsProvider>(context, listen: false)
                .fetchLevel1CommentByCommentId(
                    widget.articleId, widget.commentId, profile.uid);
        await goToCommentDetail(profile.uid, commentProvider);
      });
    }
  }

  Future<void> goToCommentDetail(
    String uid,
    CommentProvider commentProvider,
  ) async {
    await commentProvider.fetchLevel2ChildrenCommentList(uid);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CommentDetail(
              articleId: widget.articleId,
              commentProvider: commentProvider,
            ));
  }

  void onSubmitComment() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return PopUpDialog(true, "你刚刚发布了留言");
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<CommentsProvider>(context, listen: false)
            .fetchLevel1CommentListByArticleId(widget.articleId, profile.uid),
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
                    onPressed: () async {
                      await goToCommentDetail(profile.uid, comments[i]);
                    },
                    child: Comment(
                      onStartComment: () =>
                          goToCommentDetail(profile.uid, comments[i]),
                      onSubmitComment: onSubmitComment,
                    )),
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
