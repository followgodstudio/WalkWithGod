import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../providers/user/saved_articles_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/my_icon_button.dart';
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
        color: Theme.of(context).canvasColor,
        child: Row(children: [
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 40,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("您可以在此添加想法",
                            style: Theme.of(context).textTheme.captionMedium2),
                      ],
                    ),
                    onPressed: () {
                      if (profile.uid == null) {
                        showPopUpDialog(context, false, "请登录后再操作");
                      } else {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => PopUpComment(
                                  isReply: false,
                                  articleId: articleId,
                                  onPressFunc: (String content) async {
                                    exceptionHandling(rootContext, () async {
                                      await Provider.of<CommentsProvider>(
                                              context,
                                              listen: false)
                                          .addLevel1Comment(
                                              articleId,
                                              content,
                                              profile.uid,
                                              profile.name,
                                              profile.imageUrl);
                                      onLeaveCommentScroll();
                                      showPopUpDialog(
                                          rootContext, true, "你刚刚发布了想法");
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
          ),
          SizedBox(width: 10.0),
          MyIconButton(
            hasBorder: true,
            icon: 'share',
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => ShareArticle(articleId));
            },
          ),
          SizedBox(width: 10.0),
          Consumer<SavedArticlesProvider>(
            builder: (context, value, child) =>
                (profile.uid != null && value.currentLike)
                    ? MyIconButton(
                        hasBorder: true,
                        buttonColor: MyColors.lightBlue,
                        iconColor: Colors.white,
                        icon: 'save',
                        onPressed: () {
                          value.removeSavedByArticleId(articleId);
                        })
                    : MyIconButton(
                        hasBorder: true,
                        icon: 'save_border',
                        onPressed: () {
                          if (profile.uid == null) {
                            showPopUpDialog(context, false, "请登录后再操作");
                          } else {
                            value.addSavedByArticleId(
                                articleId,
                                Provider.of<ArticlesProvider>(context,
                                    listen: false));
                          }
                        }),
          ),
          SizedBox(width: 15.0),
        ]));
  }
}
