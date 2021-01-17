import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class RecentReadProvider with ChangeNotifier {
  var fdb;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int readsCount = 0;
  int readDuration = 0;
  List<String> recentReadStringList = [];
  List<ArticleProvider> recentRead = [];
  bool noMoreRecentRead = false;
  int _lastVisibleRecentRead = 0;
  bool _isFetchingRecentRead = false; // To avoid frequently request
  bool _isUpdatingRecentRead = false; // To avoid frequently request

  void setProvider(dynamic fdb, String userId) {
    this.fdb = fdb;
    _userId = userId;
  }

  Future<void> fetchRecentRead() async {
    if (readsCount == 0) return;
    _logger.i("RecentReadProvider-fetchRecentRead");
    QuerySnapshot query = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserReadHistory)
        .where(fUpdatedDate,
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
        .orderBy(fUpdatedDate, descending: true)
        .get();
    recentReadStringList = [];
    recentRead = [];
    query.docs.forEach((data) {
      recentReadStringList.add(data.id);
    });
    _lastVisibleRecentRead = 0;
    await _appendrecentReadStringList();
  }

  Future<void> fetchMoreRecentRead() async {
    if (readsCount == 0 || noMoreRecentRead || _isFetchingRecentRead) return;
    _logger.i("RecentReadProvider-fetchMoreRecentRead");
    _isFetchingRecentRead = true;
    await _appendrecentReadStringList();
    _isFetchingRecentRead = false;
  }

  Future<void> addRecentRead(ArticleProvider articleProvider) async {
    if (_isUpdatingRecentRead || _userId == null) return;
    _logger.i("RecentReadProvider-addRecentRead");
    _isUpdatingRecentRead = true;

    // update local variables
    recentReadStringList.removeWhere((item) => (item == articleProvider.id));
    recentReadStringList.insert(0, articleProvider.id);
    recentRead.removeWhere((item) => (item.id == articleProvider.id));
    recentRead.insert(0, articleProvider);

    // update remote database
    DocumentReference user = fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserProfile)
        .doc(dUserProfileStatistics);
    DocumentReference history = fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserReadHistory)
        .doc(articleProvider.id);
    DocumentSnapshot doc = await history.get();

    WriteBatch batch = fdb.batch();
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
    if (_userId == null) return;
    _logger.i("RecentReadProvider-updateReadDuration");
    int timeDiffInSecond = DateTime.now().difference(start).inSeconds;
    await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserProfile)
        .doc(dUserProfileStatistics)
        .update(
            {fUserReadDuration: FieldValue.increment(timeDiffInSecond / 3600)});
    notifyListeners();
  }

  Future<void> _appendrecentReadStringList() async {
    if (recentReadStringList.length <= _lastVisibleRecentRead) return;
    Map<String, int> itemsMap = {};
    int end = 10 + _lastVisibleRecentRead;
    if (end >= recentReadStringList.length) {
      end = recentReadStringList.length;
      noMoreRecentRead = true;
    }
    for (var i = _lastVisibleRecentRead; i < end; i++) {
      itemsMap[recentReadStringList[i]] = i;
    }
    // Fetch Document's basic info, cannot be more than 10
    List<ArticleProvider> articles = await ArticlesProvider.fetchList(
        recentReadStringList.sublist(_lastVisibleRecentRead, end));
    // Some articles may be deleted, need to remove it from list too
    List<String> removedArticles = [];
    for (var i = _lastVisibleRecentRead; i < end; i++) {
      ArticleProvider tmp = articles.firstWhere(
          (a) => a.id == recentReadStringList[i],
          orElse: () => null);
      if (tmp == null) removedArticles.add(recentReadStringList[i]);
    }
    recentReadStringList.removeWhere((a) => removedArticles.contains(a));
    // Reorganize by update date (orginal sequence)
    articles.sort((a, b) {
      return itemsMap[a.id].compareTo(itemsMap[b.id]);
    });
    articles.forEach((element) {
      recentRead.add(element);
    });
    _lastVisibleRecentRead = end - removedArticles.length;
    notifyListeners();
  }
}
