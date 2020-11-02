import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class SavedArticlesProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int savedArticlesCount = 0;
  List<ArticleProvider> _articles = [];
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request
  bool _currentLike = false; // for the article screen

  // getters and setters

  void setUserId(String userId) {
    _userId = userId;
  }

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  bool get noMore {
    return _noMore;
  }

  bool get currentLike {
    return _currentLike;
  }

  // methods

  Future<void> fetchSavedList([int limit = loadLimit]) async {
    if (_isFetching) return;
    _logger.i("SavedArticlesProvider-fetchSavedList");
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserSavedarticles)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    _articles = [];
    _noMore = false;
    await _appendSavedList(query, limit);
    notifyListeners();
    _isFetching = false;
  }

  Future<void> fetchMoreSavedArticles([int limit = loadLimit]) async {
    if (_userId == null || _noMore || _isFetching) return;
    _logger.i("SavedArticlesProvider-fetchMoreSavedArticles");
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserSavedarticles)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .get();
    await _appendSavedList(query, limit);
    _isFetching = false;
  }

  Future<void> fetchSavedStatusByArticleId(String articleId) async {
    if (_userId == null || articleId == null) return;
    ArticleProvider article =
        _articles.firstWhere((element) => element.id == articleId, orElse: () {
      return null;
    });
    if (article != null) {
      _currentLike = true;
    } else {
      _logger.i("SavedArticlesProvider-fetchSavedStatusByArticleId");
      DocumentSnapshot doc = await _db
          .collection(cUsers)
          .doc(_userId)
          .collection(cUserSavedarticles)
          .doc(articleId)
          .get();
      _currentLike = doc.exists;
    }
    notifyListeners();
  }

  Future<void> removeSavedByArticleId(String articleId) async {
    if (_userId == null || articleId == null) return;
    _logger.i("SavedArticlesProvider-removeSavedByArticleId");
    _articles.removeWhere((item) => item.id == articleId);
    savedArticlesCount = _articles.length;
    _currentLike = false;
    notifyListeners();
    // Update remote database
    WriteBatch batch = _db.batch();
    batch.delete(_db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserSavedarticles)
        .doc(articleId));
    batch.update(
        _db
            .collection(cUsers)
            .doc(_userId)
            .collection(cUserProfile)
            .doc(dUserProfileStatic),
        {fUserSavedArticlesCount: savedArticlesCount});
    await batch.commit();
  }

  Future<void> addSavedByArticleId(
      String articleId, ArticlesProvider articlesProvider) async {
    if (_userId == null || articleId == null) return;
    _logger.i("SavedArticlesProvider-addSavedByArticleId");
    _currentLike = true;
    // Get article info
    ArticleProvider article =
        await articlesProvider.fetchArticlePreviewById(articleId);
    _articles.insert(0, article);
    savedArticlesCount = _articles.length;
    notifyListeners();
    // Update remote database
    WriteBatch batch = _db.batch();
    batch.set(
        _db
            .collection(cUsers)
            .doc(_userId)
            .collection(cUserSavedarticles)
            .doc(articleId),
        {fCreatedDate: Timestamp.now()});
    batch.update(
        _db
            .collection(cUsers)
            .doc(_userId)
            .collection(cUserProfile)
            .doc(dUserProfileStatic),
        {fUserSavedArticlesCount: savedArticlesCount});
    await batch.commit();
  }

  Future<void> _appendSavedList(QuerySnapshot query, int limit) async {
    List<DocumentSnapshot> docs = query.docs;
    if (docs.length == 0) return;
    List<String> items = [];
    Map<String, int> itemsMap = {};
    for (var i = 0; i < docs.length; i++) {
      items.add(docs[i].id);
      itemsMap[docs[i].id] = i;
    }
    if (docs.length < limit) _noMore = true;
    _lastVisible = docs[docs.length - 1];
    // Fetch Document's basic info, cannot be more than 10
    List<ArticleProvider> articles = await ArticlesProvider.fetchList(items);
    // Reorganize by update date (orginal sequence)
    articles.sort((a, b) {
      return itemsMap[a.id].compareTo(itemsMap[b.id]);
    });
    articles.forEach((element) {
      _articles.add(element);
    });
    if (_noMore && savedArticlesCount != _articles.length) {
      _logger.i("SavedArticlesProvider-savedArticlesCount updated to " +
          _articles.length.toString());
      await _db
          .collection(cUsers)
          .doc(_userId)
          .collection(cUserProfile)
          .doc(dUserProfileStatic)
          .update({fUserSavedArticlesCount: _articles.length});
      savedArticlesCount = _articles.length;
    }
    notifyListeners();
  }
}
