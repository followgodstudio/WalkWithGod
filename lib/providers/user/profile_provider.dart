import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../configurations/constants.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class ProfileProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String uid;
  String name;
  String imageUrl;
  DateTime createdDate;
  int readsCount;
  int readDuration;
  int followersCount;
  int savedArticlesCount;
  List<String> _recentReadList = [];
  List<ArticleProvider> recentRead = [];
  bool _noMoreRecentRead = false;
  int _lastVisibleRecentRead = 0;
  bool _isFetching = false; // To avoid frequently request

  ProfileProvider([this.uid]);

  Stream<Map<String, dynamic>> fetchProfileStream() {
    if (uid == null || uid == "") return null;
    Stream<DocumentSnapshot> stream =
        _db.collection(cUsers).document(uid).snapshots();
    // watch message count stream
    return stream.map((DocumentSnapshot doc) {
      return {
        fUserUnreadMsgCount: doc.data[fUserUnreadMsgCount] == null
            ? 0
            : doc.data[fUserUnreadMsgCount],
        fUserMessagesCount: doc.data[fUserMessagesCount] == null
            ? 0
            : doc.data[fUserMessagesCount],
        fUserFollowingsCount: doc.data[fUserFollowingsCount] == null
            ? 0
            : doc.data[fUserFollowingsCount],
        fUserFollowersCount: doc.data[fUserFollowersCount] == null
            ? 0
            : doc.data[fUserFollowersCount]
      };
    });
  }

  Future<void> fetchBasicProfile() async {
    if (uid == null || uid == "") return;
    DocumentSnapshot doc = await _db.collection(cUsers).document(uid).get();
    if (!doc.exists) return;
    name = doc.data[fUserName];
    if (imageUrl == null) imageUrl = doc.data[fUserImageUrl];
    createdDate = (doc.data[fCreatedDate] as Timestamp).toDate();
    readDuration = (doc.data[fUserReadDuration] == null)
        ? 0
        : doc.data[fUserReadDuration].floor();
    readsCount =
        (doc.data[fUserReadsCount] == null) ? 0 : doc.data[fUserReadsCount];
    followersCount = (doc.data[fUserFollowersCount] == null)
        ? 0
        : doc.data[fUserFollowersCount];
    savedArticlesCount = (doc.data[fUserSavedArticlesCount] == null)
        ? 0
        : doc.data[fUserSavedArticlesCount];
  }

  Future<void> fetchRecentRead() async {
    if (readsCount == 0) return;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .document(uid)
        .collection(cUserReadHistory)
        .where(fUpdatedDate,
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
        .orderBy(fUpdatedDate, descending: true)
        .getDocuments();
    query.documents.forEach((data) {
      _recentReadList.add(data.documentID);
    });
    _lastVisibleRecentRead = 0;
    await _appendRecentReadList();
  }

  Future<void> fetchNetworkProfile() async {
    await fetchBasicProfile();
    await fetchRecentRead();
  }

  Future<void> initProfile(String userId) async {
    uid = userId;
    await _db.collection(cUsers).document(uid).setData({});
    String newName = "弟兄姊妹"; // TODO: Random name
    await updateProfile(newName: newName, newCreatedDate: Timestamp.now());
  }

  Future<void> updateProfilePicture(File file) async {
    String path = sProfilePictures + "/$uid.jpeg";
    StorageTaskSnapshot snapshot =
        await _storage.ref().child(path).putFile(file).onComplete;
    if (snapshot.error != null) return;
    if (imageUrl == null) {
      imageUrl = await snapshot.ref.getDownloadURL();
      imageUrl = imageUrl.substring(0, imageUrl.indexOf('&token='));
      // update profile in database
      await updateProfile(newImageUrl: imageUrl);
    } else {
      // To guarantee the image will be reloaded instead of using cache
      String uniqueKey = DateFormat('yyyyMMddkkmmss').format(DateTime.now());
      if (imageUrl.contains('&v='))
        imageUrl = imageUrl.substring(0, imageUrl.indexOf('&'));
      imageUrl = imageUrl + "&v=" + uniqueKey;
      notifyListeners();
    }
  }

  Future<void> updateProfile(
      {String newName, String newImageUrl, Timestamp newCreatedDate}) async {
    Map<String, dynamic> data = {};
    if (newName != null && newName.isNotEmpty) name = data[fUserName] = newName;
    if (newImageUrl != null && newImageUrl.isNotEmpty)
      imageUrl = data[fUserImageUrl] = newImageUrl;
    if (newCreatedDate != null) {
      createdDate = newCreatedDate.toDate();
      data[fCreatedDate] = newCreatedDate;
    }
    if (data.isNotEmpty) {
      await _db.collection(cUsers).document(uid).updateData(data);
      notifyListeners();
    }
  }

  Future<void> updateRecentReadByAid(String articleId) async {
    DocumentReference user = _db.collection(cUsers).document(uid);
    DocumentReference history = _db
        .collection(cUsers)
        .document(uid)
        .collection(cUserReadHistory)
        .document(articleId);
    DocumentSnapshot doc = await history.get();

    WriteBatch batch = _db.batch();
    if (doc.exists) {
      // Update read history timestamp
      batch.updateData(history, {fUpdatedDate: Timestamp.now()});
    } else {
      // Create a new document in read history
      batch.setData(history, {fUpdatedDate: Timestamp.now()});
      // Increase count
      batch.updateData(user, {fUserReadsCount: FieldValue.increment(1)});
    }
    await batch.commit();
  }

  Future<void> updateReadDuration(DateTime start) async {
    int timeDiffInSecond = DateTime.now().difference(start).inSeconds;
    await _db.collection(cUsers).document(uid).updateData(
        {fUserReadDuration: FieldValue.increment(timeDiffInSecond / 3600)});
  }

  Future<void> _appendRecentReadList() async {
    if (_recentReadList.length == _lastVisibleRecentRead) return;
    Map<String, int> itemsMap = {};
    int end = 10 + _lastVisibleRecentRead;
    if (end > _recentReadList.length) {
      end = _recentReadList.length;
      _noMoreRecentRead = true;
    }
    for (var i = _lastVisibleRecentRead; i < end; i++) {
      itemsMap[_recentReadList[i]] = i;
    }
    // Fetch Document's basic info, cannot be more than 10
    List<ArticleProvider> articles = await ArticlesProvider()
        .fetchList(_recentReadList.sublist(_lastVisibleRecentRead, end));
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
