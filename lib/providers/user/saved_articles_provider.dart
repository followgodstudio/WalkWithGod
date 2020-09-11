import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class SavedArticlesProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  List<ArticleProvider> _articles = [];
  String _userId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request
  bool _currentLike = false; // for the article screen

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  bool get noMore {
    return _noMore;
  }

  bool get currentLike {
    return _currentLike;
  }

  Future<void> fetchSavedListByUid(String userId,
      [int limit = loadLimit]) async {
    if (userId == null) return [];
    QuerySnapshot query = await _db
        .collection(cUsers)
        .document(userId)
        .collection(cUserSavedarticles)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _articles = [];
    _noMore = false;
    _userId = userId;
    await _appendSavedList(query, limit);
  }

  Future<void> fetchMoreSavedArticles([int limit = loadLimit]) async {
    if (_userId == null || _noMore || _isFetching) return;
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .document(_userId)
        .collection(cUserSavedarticles)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .getDocuments();
    await _appendSavedList(query, limit);
    _isFetching = false;
  }

  Future<void> fetchSavedStatusByAid(String userId, String articleId) async {
    _userId = userId;
    DocumentSnapshot doc = await _db
        .collection(cUsers)
        .document(_userId)
        .collection(cUserSavedarticles)
        .document(articleId)
        .get();
    _currentLike = doc.exists;
  }

  Future<void> removeSavedByAid(String articleId) async {
    _articles.removeWhere((item) => item.id == articleId);
    _currentLike = false;
    notifyListeners();
    // Update remote database
    WriteBatch batch = _db.batch();
    batch.delete(_db
        .collection(cUsers)
        .document(_userId)
        .collection(cUserSavedarticles)
        .document(articleId));
    batch.updateData(_db.collection(cUsers).document(_userId),
        {fUserSavedArticlesCount: FieldValue.increment(-1)});
    await batch.commit();
  }

  Future<void> addSavedByAid(String articleId) async {
    _currentLike = true;
    // Get article info
    ArticleProvider article =
        await ArticlesProvider().fetchArticlePreviewById(articleId);
    _articles.insert(0, article);
    notifyListeners();
    // Update remote database
    WriteBatch batch = _db.batch();
    batch.setData(
        _db
            .collection(cUsers)
            .document(_userId)
            .collection(cUserSavedarticles)
            .document(articleId),
        {fCreatedDate: Timestamp.now()});
    batch.updateData(_db.collection(cUsers).document(_userId),
        {fUserSavedArticlesCount: FieldValue.increment(1)});
    await batch.commit();
  }

  Future<void> _appendSavedList(QuerySnapshot query, int limit) async {
    List<DocumentSnapshot> docs = query.documents;
    if (docs.length == 0) return;
    List<String> items = [];
    Map<String, int> itemsMap = {};
    for (var i = 0; i < docs.length; i++) {
      items.add(docs[i].documentID);
      itemsMap[docs[i].documentID] = i;
    }
    if (docs.length < limit) _noMore = true;
    _lastVisible = query.documents[query.documents.length - 1];
    // Fetch Document's basic info, cannot be more than 10
    List<ArticleProvider> articles = await ArticlesProvider().fetchList(items);
    // Reorganize by update date (orginal sequence)
    articles.sort((a, b) {
      return itemsMap[a.id].compareTo(itemsMap[b.id]);
    });
    articles.forEach((element) {
      _articles.add(element);
    });
    notifyListeners();
  }
}
