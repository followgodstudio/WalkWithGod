import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/article/article_provider.dart';
import '../../providers/article/articles_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import 'article_body.dart';
import 'bottom_bar.dart';
import 'comments.dart';
import 'similar_articles.dart';
import 'top_bar.dart';

//ignore: must_be_immutable
class ArticleScreen extends StatefulWidget {
  static const routeName = '/article_screen';

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _fetchedAllData = false;

  final dataKey = new GlobalKey();

  void _scrollToComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dataKey.currentContext != null)
        Scrollable.ensureVisible(dataKey.currentContext,
            duration: Duration(seconds: 1));
    });
  }

  void fetchAllArticleData(BuildContext context, String articleId) {
    if (_fetchedAllData) return;
    _fetchedAllData = true;
    exceptionHandling(context, () async {
      ArticlesProvider articles =
          Provider.of<ArticlesProvider>(context, listen: false);
      ArticleProvider article =
          Provider.of<ArticleProvider>(context, listen: false);
      ArticleProvider _article = articles.findArticleInListById(articleId);
      article.deepCopy(_article, false);
      if (_article == null) {
        _article = await Provider.of<ArticlesProvider>(context, listen: false)
            .fetchArticlePreviewById(articleId);
        article.deepCopy(_article, true);
      }
      await article.fetchArticleContent();
      ProfileProvider profile =
          Provider.of<ProfileProvider>(context, listen: false);
      await profile.savedArticlesProvider
          .fetchSavedStatusByArticleId(article.id);
      await Provider.of<CommentsProvider>(context, listen: false)
          .fetchLevel1CommentListByArticleId(article.id, profile.uid);
      await article.fetchSimilarArticles();
      await profile.recentReadProvider.addRecentRead(article);
    });
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("ArticleScreen-build");
    final Map parameter = ModalRoute.of(context).settings.arguments as Map;
    final String _articleId = parameter["articleId"];
    final String _commentId = parameter["commentId"];
    final HideNavbar hiding = HideNavbar();
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    fetchAllArticleData(context, _articleId);
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                exceptionHandling(context, () async {
                  await Provider.of<CommentsProvider>(context, listen: false)
                      .fetchMoreLevel1Comments(profile.uid);
                });
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
                      ArticleBody(),
                      SimilarArticles(),
                      Comments(articleId: _articleId, commentId: _commentId),
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
