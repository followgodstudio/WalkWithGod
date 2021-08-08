import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../configurations/constants.dart';
import '../../exceptions/my_exception.dart';
import '../../utils/my_logger.dart';
import 'friends_provider.dart';
import 'messages_provider.dart';
import 'recent_read_provider.dart';
import 'saved_articles_provider.dart';
import 'setting_provider.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseFirestore fdb = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  MyLogger _logger = MyLogger("Provider");
  // Basic info
  String uid;
  String name = defaultUserName;
  String imageUrl;
  // Providers
  FriendsProvider friendsProvider = FriendsProvider();
  SavedArticlesProvider savedArticlesProvider = SavedArticlesProvider();
  MessagesProvider messagesProvider = MessagesProvider();
  SettingProvider settingProvider = SettingProvider();
  RecentReadProvider recentReadProvider = RecentReadProvider();

  bool _isFetching = false; // to avoid frequent request
  bool _isFetchedAll = false;

  ProfileProvider([this.uid]) {
    _logger.i("ProfileProvider-init");
    friendsProvider.setProvider(fdb, uid);
    savedArticlesProvider.setProvider(fdb, uid);
    messagesProvider.setProvider(fdb, uid);
    settingProvider.setProvider(fdb, uid);
    recentReadProvider.setProvider(fdb, uid);
  }

  Future<void> fetchAllUserData() async {
    if (uid == null || _isFetching || _isFetchedAll) return;
    _logger.i("ProfileProvider-fetchAllUserData");
    _isFetchedAll = true;
    _isFetching = true;
    DateTime start = DateTime.now();
    try {
      await fetchProfile();
      await savedArticlesProvider.fetchSavedList();
      await friendsProvider.fetchFriendList(true);
      await friendsProvider.fetchFriendList(false);
      await messagesProvider.fetchMessageList();
      await recentReadProvider.fetchRecentRead();
    } on Exception catch (error) {
      _isFetching = false;
      throw error;
    }
    _isFetching = false;
    _logger.i("ProfileProvider-fetchAllUserData takes: " +
        DateTime.now().difference(start).inMilliseconds.toString() +
        "ms.");
  }

  Future<bool> fetchProfile() async {
    _logger.i("ProfileProvider-fetchProfile");
    try {
      DocumentSnapshot doc = await fdb.collection(cUsers).doc(uid).get();
      if (!doc.exists) {
        // User profile does not exist, init profile
        await initProfile();
        doc = await fdb.collection(cUsers).doc(uid).get();
      }
      Map<String, dynamic> docData = doc.data();
      if (docData.containsKey(fUserName)) name = doc.get(fUserName);
      if ((imageUrl == null || imageUrl.isEmpty) &&
          docData.containsKey(fUserImageUrl))
        imageUrl = doc.get(fUserImageUrl); // Only fetch once

      DocumentSnapshot docStatistics = await fdb
          .collection(cUsers)
          .doc(uid)
          .collection(cUserProfile)
          .doc(dUserProfileStatistics)
          .get();
      if (docStatistics.exists) {
        Map<String, dynamic> docStatisticsData = docStatistics.data();
        if (docStatisticsData.containsKey(fUserReadDuration))
          recentReadProvider.readDuration =
              docStatistics.get(fUserReadDuration).floor();
        if (docStatisticsData.containsKey(fUserReadsCount))
          recentReadProvider.readsCount = docStatistics.get(fUserReadsCount);
        if (docStatisticsData.containsKey(fUserFollowingsCount))
          friendsProvider.followingsCount =
              docStatistics.get(fUserFollowingsCount);
        if (docStatisticsData.containsKey(fUserFollowersCount))
          friendsProvider.followersCount =
              docStatistics.get(fUserFollowersCount);
        friendsProvider.notifyListeners();
        if (docStatisticsData.containsKey(fUserMessagesCount))
          messagesProvider.messagesCount =
              docStatistics.get(fUserMessagesCount);
        if (docStatisticsData.containsKey(fUserUnreadMsgCount))
          messagesProvider.unreadMessagesCount =
              docStatistics.get(fUserUnreadMsgCount);
        messagesProvider.notifyListeners();
        if (docStatisticsData.containsKey(fUserSavedArticlesCount))
          savedArticlesProvider.savedArticlesCount =
              docStatistics.get(fUserSavedArticlesCount);
      }
      DocumentSnapshot docSetting = await fdb
          .collection(cUsers)
          .doc(uid)
          .collection(cUserProfile)
          .doc(dUserProfileSettings)
          .get();
      if (docSetting.exists) settingProvider.getSetting(docSetting);
      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      String message = error.message;
      //TODO: define our error message here
      throw (MyException(message));
    }
  }

  Future<void> updateProfilePicture(File file) async {
    _logger.i("ProfileProvider-updateProfilePicture");
    final ref = FirebaseStorage.instance
        .ref()
        .child(sProfilePictures)
        .child('$uid.jpeg');
    String imageUrl = await ref.getDownloadURL();
    if (imageUrl == null || imageUrl.isEmpty) {
      // newUrl = newUrl.substring(0, newUrl.indexOf('&token='));
      //TODO: Test
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

  Future<void> updateProfile({String newName, String newImageUrl}) async {
    Map<String, dynamic> data = {};
    if (newName != null && newName.isNotEmpty && name != newName)
      name = data[fUserName] = newName;
    if (newImageUrl != null &&
        newImageUrl.isNotEmpty &&
        newImageUrl != imageUrl) imageUrl = data[fUserImageUrl] = newImageUrl;
    if (data.isNotEmpty) {
      _logger.i("ProfileProvider-updateProfilePicture");
      await fdb.collection(cUsers).doc(uid).update(data);
      notifyListeners();
    }
  }

  Future<void> initProfile() async {
    _logger.i("ProfileProvider-initProfile");
    WriteBatch batch = fdb.batch();
    batch.set(fdb.collection(cUsers).doc(uid), {fUserName: name});
    batch.set(
        fdb
            .collection(cUsers)
            .doc(uid)
            .collection(cUserProfile)
            .doc(dUserProfileStatistics),
        {fCreatedDate: Timestamp.fromDate(DateTime.now())});
    await batch.commit();
  }

  Future<void> deleteProfile() async {
    _logger.i("ProfileProvider-deleteProfile");
    await fdb.collection(cUsers).doc(uid).delete();
  }
}
