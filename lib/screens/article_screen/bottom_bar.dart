import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../providers/user/saved_articles_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/popup_comment.dart';
import 'share_article.dart';

class BottomBar extends StatelessWidget {
  final String articleId;
  final Function onLeaveCommentScroll;
  BottomBar(this.articleId, this.onLeaveCommentScroll);

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("BottomBar-build");
    BuildContext rootContext = context;
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return BottomAppBar(
        child: Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("您可以在此添加想法",
                      style: Theme.of(context).textTheme.captionMedium3),
                ],
              ),
              onPressed: () {
                if (profile.uid == null) {
                  showPopUpDialog(context, false, "请登陆后再操作");
                } else {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => PopUpComment(
                            articleId: articleId,
                            onPressFunc: (String content) async {
                              exceptionHandling(rootContext, () async {
                                await Provider.of<CommentsProvider>(context,
                                        listen: false)
                                    .addLevel1Comment(
                                        articleId,
                                        content,
                                        profile.uid,
                                        profile.name,
                                        profile.imageUrl);
                                onLeaveCommentScroll();
                                showPopUpDialog(rootContext, true, "你刚刚发布了留言");
                              });
                            },
                          ));
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Theme.of(context).buttonColor),
        ),
      ),
      SizedBox(
        width: 55.0,
        child: FlatButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => ShareArticle(articleId));
          },
          child: Icon(
            Icons.share,
            size: 20.0,
          ),
          color: Theme.of(context).buttonColor,
          shape: CircleBorder(),
        ),
      ),
      SizedBox(
          width: 55.0,
          child: Consumer<SavedArticlesProvider>(
              builder: (context, value, child) => FlatButton(
                    onPressed: () {
                      if (profile.uid == null) {
                        showPopUpDialog(context, false, "请登陆后再操作");
                      } else {
                        if (value.currentLike) {
                          value.removeSavedByArticleId(articleId);
                        } else {
                          value.addSavedByArticleId(
                              articleId,
                              Provider.of<ArticlesProvider>(context,
                                  listen: false));
                        }
                      }
                    },
                    child: Icon(
                      (profile.uid != null && value.currentLike)
                          ? Icons.star
                          : Icons.star_border,
                      size: 20.0,
                      color: (profile.uid != null && value.currentLike)
                          ? Colors.white
                          : Colors.black87,
                    ),
                    color: (profile.uid != null && value.currentLike)
                        ? Colors.blue
                        : Theme.of(context).buttonColor,
                    shape: CircleBorder(),
                  ))),
    ]));
  }
}
