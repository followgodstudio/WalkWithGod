import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../configurations/constants.dart';
import 'friends_provider.dart';
import 'messages_provider.dart';
import 'recent_read_provider.dart';
import 'saved_articles_provider.dart';
import 'setting_provider.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Basic info
  String uid;
  String name = defaultUserName;
  String imageUrl;
  // Network info
  DateTime createdDate;
  int unreadMessagesCount = 0;
  int messagesCount = 0;
  int followersCount = 0;
  // Providers
  FriendsProvider friendsProvider = FriendsProvider();
  SavedArticlesProvider savedArticlesProvider = SavedArticlesProvider();
  MessagesProvider messagesProvider = MessagesProvider();
  SettingProvider settingProvider = SettingProvider();
  RecentReadProvider recentReadProvider = RecentReadProvider();

  bool _isFetching = false; // to avoid frequent request
  bool _isFetchedAll = false;

  ProfileProvider([this.uid]);

  Future<void> fetchAllUserInfo(String userId) async {
    if (userId == null || userId.isEmpty || _isFetching || _isFetchedAll)
      return;
    print("ProfileProvider-fetchAllUserInfo");
    uid = userId;
    _isFetchedAll = true;
    friendsProvider.setUserId(uid);
    savedArticlesProvider.setUserId(uid);
    messagesProvider.setUserId(uid);
    settingProvider.setUserId(uid);
    recentReadProvider.setUserId(uid);

    _isFetching = true;
    DateTime start = DateTime.now();
    //TODO: exception handling
    if (!await fetchProfile()) return false;
    await savedArticlesProvider.fetchSavedList();
    await friendsProvider.fetchFriendList(true, followersCount);
    await friendsProvider.fetchFriendList(false);
    await messagesProvider.fetchMessageList(messagesCount);
    await settingProvider.fetchAboutUs();
    await settingProvider.fetchNewestVersion();
    await recentReadProvider.fetchRecentRead();

    _isFetching = false;
    print("ProfileProvider-fetchAllUserInfo takes: " +
        DateTime.now().difference(start).inMilliseconds.toString() +
        "ms.");
  }

  Stream<Map<String, int>> fetchProfileStream() {
    Stream<DocumentSnapshot> stream = _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserProfile)
        .doc(dUserProfileDynamic)
        .snapshots();
    return stream.map((DocumentSnapshot doc) {
      Map<String, int> data = {
        fUserUnreadMsgCount: 0,
        fUserMessagesCount: 0,
        fUserFollowersCount: 0,
      };
      if (!doc.exists) return data;
      if (doc.data().containsKey(fUserUnreadMsgCount))
        unreadMessagesCount =
            data[fUserUnreadMsgCount] = doc.get(fUserUnreadMsgCount);
      if (doc.data().containsKey(fUserMessagesCount))
        messagesCount = data[fUserMessagesCount] = doc.get(fUserMessagesCount);
      if (doc.data().containsKey(fUserFollowersCount))
        followersCount =
            data[fUserFollowersCount] = doc.get(fUserFollowersCount);
      return data;
    });
  }

  Future<bool> fetchProfile() async {
    print("ProfileProvider-fetchProfile");
    DocumentSnapshot doc = await _db.collection(cUsers).doc(uid).get();
    if (!doc.exists) return false; // User not exist

    if (doc.data().containsKey(fUserName)) name = doc.get(fUserName);
    if ((imageUrl == null || imageUrl.isEmpty) &&
        doc.data().containsKey(fUserImageUrl))
      imageUrl = doc.get(fUserImageUrl); // Only fetch once

    // fetch dynamic information
    DocumentSnapshot docDynamic = await _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserProfile)
        .doc(dUserProfileDynamic)
        .get();
    if (docDynamic.exists && docDynamic.data().containsKey(fUserFollowersCount))
      friendsProvider.followersCount = docDynamic.get(fUserFollowersCount);
    if (docDynamic.exists && docDynamic.data().containsKey(fUserMessagesCount))
      messagesProvider.messagesCount = docDynamic.get(fUserMessagesCount);
    if (docDynamic.exists && docDynamic.data().containsKey(fUserUnreadMsgCount))
      messagesProvider.unreadMessagesCount =
          docDynamic.get(fUserUnreadMsgCount);

    // fetch static information
    DocumentSnapshot docStatic = await _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserProfile)
        .doc(dUserProfileStatic)
        .get();
    if (!docStatic.exists) return true;
    if (docStatic.data().containsKey(fCreatedDate))
      createdDate = (docStatic.get(fCreatedDate) as Timestamp).toDate();
    if (docStatic.data().containsKey(fUserReadDuration))
      recentReadProvider.readDuration =
          docStatic.get(fUserReadDuration).floor();
    if (docStatic.data().containsKey(fUserReadsCount))
      recentReadProvider.readsCount = docStatic.get(fUserReadsCount);
    if (docStatic.data().containsKey(fUserFollowingsCount))
      friendsProvider.followingsCount = docStatic.get(fUserFollowingsCount);
    if (docStatic.data().containsKey(fUserSavedArticlesCount))
      savedArticlesProvider.savedArticlesCount =
          docStatic.get(fUserSavedArticlesCount);
    if (docStatic.data().containsKey(fSettingScreenAwake))
      settingProvider.keepScreenAwake = docStatic.get(fSettingScreenAwake);
    if (docStatic.data().containsKey(fSettingHideRecentRead))
      settingProvider.hideRecentRead = docStatic.get(fSettingHideRecentRead);

    notifyListeners();
    return true;
  }

  Future<void> updateProfilePicture(File file) async {
    print("ProfileProvider-updateProfilePicture");
    String path = sProfilePictures + "/$uid.jpeg";
    StorageTaskSnapshot snapshot =
        await _storage.ref().child(path).putFile(file).onComplete;
    if (snapshot.error != null) return;
    if (imageUrl == null || imageUrl.isEmpty) {
      String newUrl = await snapshot.ref.getDownloadURL();
      newUrl = newUrl.substring(0, newUrl.indexOf('&token='));
      await updateProfile(newImageUrl: newUrl);
    } else {
      // To guarantee the image will be reloaded instead of using cache
      String uniqueKey = DateFormat('yyyyMMddkkmmss').format(DateTime.now());
      if (imageUrl.contains('&v='))
        imageUrl = imageUrl.substring(0, imageUrl.indexOf('&'));
      imageUrl = imageUrl + "&v=" + uniqueKey;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String newName, String newImageUrl}) async {
    Map<String, dynamic> data = {};
    if (newName != null && newName.isNotEmpty && name != newName)
      name = data[fUserName] = newName;
    if (newImageUrl != null &&
        newImageUrl.isNotEmpty &&
        newImageUrl != imageUrl) imageUrl = data[fUserImageUrl] = newImageUrl;
    if (data.isNotEmpty) {
      print("ProfileProvider-updateProfilePicture");
      await _db.collection(cUsers).doc(uid).update(data);
      notifyListeners();
    }
  }

  Future<void> initProfile() async {
    print("ProfileProvider-initProfile");
    createdDate = DateTime.now();
    await _db.collection(cUsers).doc(uid).set({fUserName: name});
    await _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserProfile)
        .doc(dUserProfileDynamic)
        .set({});
    await _db
        .collection(cUsers)
        .doc(uid)
        .collection(cUserProfile)
        .doc(dUserProfileStatic)
        .set({fCreatedDate: Timestamp.fromDate(createdDate)});
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    print("ProfileProvider-deleteProfile");
    await _db.collection(cUsers).doc(uid).delete();
  }
}
