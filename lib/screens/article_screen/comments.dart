import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/comment.dart';
import '../../widgets/my_bottom_indicator.dart';
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
        await exceptionHandling(context, () async {
          CommentProvider commentProvider =
              await Provider.of<CommentsProvider>(context, listen: false)
                  .fetchLevel1CommentByCommentId(
                      widget.articleId, widget.commentId, profile.uid);
          await goToCommentDetail(profile.uid, commentProvider);
        });
      });
    }
  }

  Future<void> goToCommentDetail(
    String uid,
    CommentProvider commentProvider,
  ) async {
    exceptionHandling(context, () async {
      await commentProvider.fetchLevel2ChildrenCommentList(uid);
    });
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
            value: commentProvider, child: CommentDetail()));
  }

  void onSubmitComment() {
    showPopUpDialog(context, true, "你刚刚发布了回复");
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("Comments-build");
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      if (article.id == null || article.content.length == 0) return SizedBox();
      return Consumer<CommentsProvider>(builder: (context, data, child) {
        List<CommentProvider> comments = data.items;
        List<Widget> list = [];
        list.add(Divider());
        if (comments.length == 0) {
          list.add(Center(
              child: Padding(
            padding: EdgeInsets.all(verticalPadding),
            child: Text("暂无评论",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.captionMedium2),
          )));
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(children: list),
          );
        }
        for (var i = 0; i < comments.length; i++) {
          list.add(ChangeNotifierProvider.value(
              value: comments[i],
              builder: (context, _) {
                return FlatButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      await goToCommentDetail(profile.uid, comments[i]);
                    },
                    child: Comment(
                      onStartComment: () =>
                          goToCommentDetail(profile.uid, comments[i]),
                      onSubmitComment: onSubmitComment,
                    ));
              }));
        }
        list.add(MyBottomIndicator(data.noMore));
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(children: list),
        );
      });
    });
  }
}
