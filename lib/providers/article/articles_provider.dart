import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import 'article_provider.dart';

class ArticlesProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  MyLogger _logger = MyLogger("Provider");
  DocumentSnapshot _lastVisibleChild;
  bool _noMoreChild = false;
  bool _isFetching = false;
  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  bool get noMoreChild {
    return _noMoreChild;
  }

  static Future<List<ArticleProvider>> fetchList(List<String> aids) async {
    MyLogger("Provider").i("ArticlesProvider-fetchList");
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        .get();
    List<ArticleProvider> result = [];
    query.docs.forEach((data) {
      result.add(buildArticleByMap(data.id, data.data()));
    });
    return result;
  }

  Future<void> fetchArticlesByDate(
      [DateTime dateTime, int n = loadLimit]) async {
    _logger.i("ArticlesProvider-fetchArticlesByDate");
    if (dateTime == null) dateTime = DateTime.utc(1989, 11, 9);
    _isFetching = true;
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .get();
    _articles = [];
    _isFetching = false;
    setArticles(query, n);
  }

  Future<void> fetchMoreArticles([DateTime dateTime, int n = loadLimit]) async {
    if (_noMoreChild || _isFetching) return;
    _logger.i("ArticlesProvider-fetchMoreArticles");
    if (dateTime == null) dateTime = DateTime.utc(1989, 11, 9);
    _isFetching = true;
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisibleChild)
        .limit(n)
        .get();
    _isFetching = false;
    setArticles(query, n);
  }

  ArticleProvider findArticleInListById(String aid) {
    return _articles.firstWhere((a) => a.id == aid, orElse: () {
      return ArticleProvider();
    });
  }

  Future<ArticleProvider> fetchArticlePreviewById(String aid) async {
    ArticleProvider article = findArticleInListById(aid);
    if (article.id != null) return article;
    MyLogger("Provider").i("ArticlesProvider-fetchArticlePreviewById");
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection(cArticles).doc(aid).get();
    return buildArticleByMap(data.id, data.data());
  }

  void setArticles(QuerySnapshot query, int limit) {
    List<DocumentSnapshot> docs = query.docs;
    if (docs.length < limit) _noMoreChild = true;
    if (docs.length == 0) {
      notifyListeners();
      return;
    }
    docs.forEach((data) {
      _articles.add(buildArticleByMap(data.id, data.data()));
    });
    _lastVisibleChild = docs[docs.length - 1];
    notifyListeners();
  }

  static ArticleProvider buildArticleByMap(
      String id, Map<String, dynamic> data) {
    return ArticleProvider(
        id: id,
        title: data[fArticleTitle],
        description: data[fArticleDescription],
        imageUrl: data[fArticleImageUrl],
        authorName: data[fArticleAuthorName],
        authorUid: data[fArticleAuthorUid],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        icon: data[fArticleIcon],
        readCount: data[fArticleReadCount] ?? 0,
        publisher: data[fArticlePublisher]);
  }
}
