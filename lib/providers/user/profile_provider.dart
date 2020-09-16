import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';

import '../../configurations/constants.dart';
import '../article/article_provider.dart';
import '../article/articles_provider.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Basic info
  String uid;
  String name;
  String imageUrl;
  // Network info
  DateTime createdDate;
  int readsCount;
  int readDuration;
  int followersCount;
  int savedArticlesCount;
  // Settings
  bool keepScreenAwakeOnRead = false;
  // For recent read
  List<String> _recentReadList = [];
  List<ArticleProvider> recentRead = [];
  bool noMoreRecentRead = false;
  int _lastVisibleRecentRead = 0;
  bool _isFetchingRecentRead = false; // To avoid frequently request
  bool _isUpdatingRecentRead = false; // To avoid frequently request

  ProfileProvider([this.uid]);

  Stream<Map<String, dynamic>> fetchProfileStream() {
    if (uid == null || uid == "") return null;
    Stream<DocumentSnapshot> stream =
        _db.collection(cUsers).doc(uid).snapshots();
    // watch message count stream
    return stream.map((DocumentSnapshot doc) {
      return {
        fUserUnreadMsgCount: doc.data().containsKey(fUserUnreadMsgCount)
            ? doc.get(fUserUnreadMsgCount)
            : 0,
        fUserMessagesCount: doc.data().containsKey(fUserMessagesCount)
            ? doc.get(fUserMessagesCount)
            : 0,
        fUserFollowingsCount: doc.data().containsKey(fUserFollowingsCount)
            ? doc.get(fUserFollowingsCount)
            : 0,
        fUserFollowersCount: doc.data().containsKey(fUserFollowersCount)
            ? doc.get(fUserFollowersCount)
            : 0,
      };
    });
  }

  Future<void> fetchBasicProfile() async {
    if (uid == null || uid == "") return;
    DocumentSnapshot doc = await _db.collection(cUsers).doc(uid).get();
    if (!doc.exists) return;
    name = doc.get(fUserName);

    if (imageUrl == null) {
      imageUrl =
          doc.data().containsKey(fUserImageUrl) ? doc.get(fUserImageUrl) : null;
      // try {
      //   imageUrl = (doc.get(fUserImageUrl) == null)
      //       ? imageUrl
      //       : doc.get(fUserImageUrl);
      // } catch (err) {
      //   print(err);
      // }
    }
    createdDate = (doc.get(fCreatedDate) as Timestamp).toDate();

    readDuration = doc.data().containsKey(fUserReadDuration)
        ? doc.get(fUserReadDuration).floor()
        : 0;
    readsCount =
        doc.data().containsKey(fUserReadsCount) ? doc.get(fUserReadsCount) : 0;
    followersCount = doc.data().containsKey(fUserFollowersCount)
        ? doc.get(fUserFollowersCount)
        : 0;
    savedArticlesCount = doc.data().containsKey(fUserSavedArticlesCount)
        ? doc.get(fUserSavedArticlesCount)
        : 0;
  }

  Future<void> fetchRecentRead() async {
    if (readsCount == 0) return;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserReadHistory)
        .where(fUpdatedDate,
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
        .orderBy(fUpdatedDate, descending: true)
        .get();
    query.docs.forEach((data) {
      _recentReadList.add(data.id);
    });
    _lastVisibleRecentRead = 0;
    await _appendRecentReadList();
  }

  Future<void> fetchMoreRecentRead() async {
    if (readsCount == 0 || noMoreRecentRead || _isFetchingRecentRead) return;
    _isFetchingRecentRead = true;
    await _appendRecentReadList();
    _isFetchingRecentRead = false;
  }

  Future<void> fetchNetworkProfile() async {
    await fetchBasicProfile();
    await fetchRecentRead();
  }

  Future<void> initProfile(String userId) async {
    uid = userId;
    await _db.collection(cUsers).doc(uid).set({});
    String newName = "弟兄姊妹"; // TODO: Random name
    await updateProfile(newName: newName, newCreatedDate: Timestamp.now());
  }

  Future<void> updateProfilePicture(File file) async {
    String path = sProfilePictures + "/$uid.jpeg";
    StorageTaskSnapshot snapshot =
        await _storage.ref().child(path).putFile(file).onComplete;
    if (snapshot.error != null) return;
    if (imageUrl == null || imageUrl.isEmpty) {
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
      await _db.collection(cUsers).doc(uid).update(data);
      notifyListeners();
    }
  }

  Future<void> updateRecentReadByAid(String articleId) async {
    if (_isUpdatingRecentRead) return;
    _isUpdatingRecentRead = true;

    DocumentReference user = _db.collection(cUsers).doc(uid);
    DocumentReference history = _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserReadHistory)
        .doc(articleId);
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
  }

  Future<void> updateReadDuration(DateTime start) async {
    if (uid == null || uid.isEmpty) return;
    int timeDiffInSecond = DateTime.now().difference(start).inSeconds;
    await _db.collection(cUsers).doc(uid).update(
        {fUserReadDuration: FieldValue.increment(timeDiffInSecond / 3600)});
  }

  Future<void> updateUserSetting({bool newKeepScreenAwakeOnRead}) async {
    Map<String, dynamic> data = {};
    if (newKeepScreenAwakeOnRead != null) {
      keepScreenAwakeOnRead =
          data[fUserSettingScreenAwake] = newKeepScreenAwakeOnRead;
      Wakelock.toggle(on: newKeepScreenAwakeOnRead);
    }
    if (data.isNotEmpty) {
      // await _db.collection(cUsers).document(uid).updateData(data);
      notifyListeners();
    }
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
