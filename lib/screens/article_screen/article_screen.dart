import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/article/article_provider.dart';
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
  bool _fetchedAllData = false;
  final dataKey = new GlobalKey();

  void _scrollToComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dataKey.currentContext != null)
        Scrollable.ensureVisible(dataKey.currentContext,
            duration: Duration(seconds: 1));
    });
  }

  // fetch all data that needed by the article screen, run only once
  void _fetchAllArticleData(
      BuildContext context, ArticleProvider article) async {
    if (!_fetchedAllData) {
      _fetchedAllData = true;
      await article.fetchArticleContent();
      ProfileProvider profile =
          Provider.of<ProfileProvider>(context, listen: false);
      await profile.savedArticlesProvider
          .fetchSavedStatusByArticleId(article.id);
      await Provider.of<CommentsProvider>(context, listen: false)
          .fetchLevel1CommentListByArticleId(article.id, profile.uid);
      await article.fetchSimilarArticles();
      await profile.recentReadProvider.updateRecentReadByArticleId(article);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ArticleScreen");
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    final Map parameter = ModalRoute.of(context).settings.arguments as Map;
    final String _articleId = parameter["articleId"];
    final String _commentId = parameter["commentId"];
    final HideNavbar hiding = HideNavbar();
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(_articleId);
    _fetchAllArticleData(context, loadedArticle);
    return ChangeNotifierProvider.value(
        value: loadedArticle,
        child: Scaffold(
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
                    TopBar(),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ArticleBody(),
                          ),
                          SimilarArticles(),
                          Padding(
                            key: dataKey,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                  ? BottomBar(_articleId, _scrollToComment)
                  : Container(
                      color: Colors.white,
                    ),
            ),
          ),
        ));
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
