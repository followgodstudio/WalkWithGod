import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/article/articles_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import 'article_body.dart';
import 'bottom_bar.dart';
import 'comments.dart';
import 'similar_articles.dart';
import 'top_bar.dart';

//ignore: must_be_immutable
class ArticleScreen extends StatelessWidget {
  static const routeName = '/article_screen';
  bool _updatedRecentRead = false;
  final dataKey = new GlobalKey();
  void scrollToComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dataKey.currentContext != null)
        Scrollable.ensureVisible(dataKey.currentContext,
            duration: Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map parameter = ModalRoute.of(context).settings.arguments as Map;
    final String _articleId = parameter["articleId"];
    final String _commentId = parameter["commentId"];
    final HideNavbar hiding = HideNavbar();
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    if (!_updatedRecentRead) {
      // update recently read history, run only once.
      _updatedRecentRead = true;
      final loadedArticle = Provider.of<ArticlesProvider>(
        context,
        listen: false,
      ).findById(_articleId);
      profile.recentReadProvider.updateRecentReadByArticleId(loadedArticle);
    }
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                Provider.of<CommentsProvider>(context, listen: false)
                    .fetchMoreLevel1Comments(profile.uid);
              }
              return true;
            },
            child: CustomScrollView(
              controller: hiding.controller,
              slivers: <Widget>[
                TopBar(_articleId),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ArticleBody(_articleId),
                      ),
                      SimilarArticles(_articleId),
                      Padding(
                        key: dataKey,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Comments(
                            articleId: _articleId, commentId: _commentId),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: hiding.visible,
        builder: (context, bool value, child) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: value ? 60.0 : 0.0,
          child: value
              ? BottomBar(_articleId, scrollToComment)
              : Container(
                  color: Colors.white,
                  // width: MediaQuery.of(context).size.width,
                ),
        ),
      ),
    );
  }
}

class HideNavbar {
  final ScrollController controller = ScrollController();
  ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  HideNavbar() {
    visible.value = true;
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible.value) {
            visible.value = false;
          }
        }

        if (controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible.value) {
            visible.value = true;
          }
        }
      },
    );
  }
}
