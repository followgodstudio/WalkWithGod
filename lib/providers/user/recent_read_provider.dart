import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class RecentReadProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int readsCount = 0;
  int readDuration = 0;
  List<String> _recentReadList = [];
  List<ArticleProvider> recentRead = [];
  bool noMoreRecentRead = false;
  int _lastVisibleRecentRead = 0;
  bool _isFetchingRecentRead = false; // To avoid frequently request
  bool _isUpdatingRecentRead = false; // To avoid frequently request

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> fetchRecentRead() async {
    if (readsCount == 0) return;
    _logger.i("RecentReadProvider-fetchRecentRead");
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserReadHistory)
        .where(fUpdatedDate,
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
        .orderBy(fUpdatedDate, descending: true)
        .get();
    _recentReadList = [];
    recentRead = [];
    query.docs.forEach((data) {
      _recentReadList.add(data.id);
    });
    _lastVisibleRecentRead = 0;
    await _appendRecentReadList();
  }

  Future<void> fetchMoreRecentRead() async {
    if (readsCount == 0 || noMoreRecentRead || _isFetchingRecentRead) return;
    _logger.i("RecentReadProvider-fetchMoreRecentRead");
    _isFetchingRecentRead = true;
    await _appendRecentReadList();
    _isFetchingRecentRead = false;
  }

  Future<void> updateRecentReadByArticleId(
      ArticleProvider articleProvider) async {
    if (_isUpdatingRecentRead || _userId == null || _userId.isEmpty) return;
    _logger.i("RecentReadProvider-updateRecentReadByArticleId");
    _isUpdatingRecentRead = true;

    // update local variables
    _recentReadList.removeWhere((item) => (item == articleProvider.id));
    _recentReadList.insert(0, articleProvider.id);
    recentRead.removeWhere((item) => (item.id == articleProvider.id));
    recentRead.insert(0, articleProvider);

    // update remote database
    DocumentReference user = _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserProfile)
        .doc(dUserProfileStatic);
    DocumentReference history = _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserReadHistory)
        .doc(articleProvider.id);
    DocumentSnapshot doc = await history.get();

    WriteBatch batch = _db.batch();
    if (doc.exists) {
      // Update read history timestamp
      batch.update(history, {fUpdatedDate: Timestamp.now()});
    } else {
      // Create a new document in read history
      batch.set(history, {fUpdatedDate: Timestamp.now()});
      // Increase count
      batch.update(user, {fUserReadsCount: FieldValue.increment(1)});
    }
    await batch.commit();

    _isUpdatingRecentRead = false;
    notifyListeners();
  }

  Future<void> updateReadDuration(DateTime start) async {
    if (_userId == null || _userId.isEmpty) return;
    _logger.i("RecentReadProvider-updateReadDuration");
    int timeDiffInSecond = DateTime.now().difference(start).inSeconds;
    await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserProfile)
        .doc(dUserProfileStatic)
        .update(
            {fUserReadDuration: FieldValue.increment(timeDiffInSecond / 3600)});
    notifyListeners();
  }

  Future<void> _appendRecentReadList() async {
    if (_recentReadList.length == _lastVisibleRecentRead) return;
    Map<String, int> itemsMap = {};
    int end = 10 + _lastVisibleRecentRead;
    if (end >= _recentReadList.length) {
      end = _recentReadList.length;
      noMoreRecentRead = true;
    }
    for (var i = _lastVisibleRecentRead; i < end; i++) {
      itemsMap[_recentReadList[i]] = i;
    }
    // Fetch Document's basic info, cannot be more than 10
    List<ArticleProvider> articles = await ArticlesProvider.fetchList(
        _recentReadList.sublist(_lastVisibleRecentRead, end));
    // Reorganize by update date (orginal sequence)
    articles.sort((a, b) {
      return itemsMap[a.id].compareTo(itemsMap[b.id]);
    });
    articles.forEach((element) {
      recentRead.add(element);
    });
    _lastVisibleRecentRead = end;
    notifyListeners();
  }
}
