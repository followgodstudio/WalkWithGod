import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class ProfileProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  String uid;
  String name;
  String imageUrl;
  DateTime createdDate;
  int readsCount;
  int readDuration;
  int followersCount;
  int savedArticlesCount;
  List<String> recentRead = [];

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
    imageUrl = doc.data[fUserImageUrl];
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
      recentRead.add(data.documentID);
    });
  }

  Future<ProfileProvider> fetchProfileByUid(String userId) async {
    ProfileProvider userProfile = ProfileProvider(userId);
    await userProfile.fetchBasicProfile();
    await userProfile.fetchRecentRead();
    return userProfile;
  }

  Future<void> initProfile(String userId) async {
    uid = userId;
    await _db.collection(cUsers).document(uid).setData({});
    String newName = "弟兄姊妹"; // TODO: Random name
    await updateProfile(newName: newName, newCreatedDate: Timestamp.now());
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

  Future<void> updateReadByAid(
      String articleId, DateTime start, DateTime end) async {
    int timeDiffInSecond = end.difference(start).inSeconds;
    print(uid + " " + articleId + " " + timeDiffInSecond.toString());
    if (timeDiffInSecond < 5) return;

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
      batch.updateData(history, {fUpdatedDate: Timestamp.fromDate(end)});
    } else {
      // Create a new document in read history
      batch.setData(history, {fUpdatedDate: Timestamp.fromDate(end)});
      // Increase count
      batch.updateData(user, {fUserReadsCount: FieldValue.increment(1)});
    }
    // Increase read duration
    batch.updateData(user,
        {fUserReadDuration: FieldValue.increment(timeDiffInSecond / 3600)});
    await batch.commit();
  }
}
