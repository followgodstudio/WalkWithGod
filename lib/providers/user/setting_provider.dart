import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';

class SettingProvider with ChangeNotifier {
  var fdb;
  MyLogger _logger = MyLogger("Provider");
  String userId;
  bool keepScreenAwake = false;
  bool hideRecentRead = false;
  bool allowFollowing = false;
  bool rejectStrangerMessage = false;
  List<String> blackList = [];
  bool followingNotification = false;
  String ourMission = "";
  String whoAreWe = "";
  double imageCacheSize = 0;
  int imageCacheNumber = 0;

  SettingProvider({this.fdb, this.userId});

  void setProvider(dynamic fdb, String userId) {
    this.fdb = fdb;
    this.userId = userId;
  }

  Future<void> fetchAboutUs() async {
    _logger.i("SettingProvider-fetchAboutUs");
    DocumentSnapshot doc =
        await fdb.collection(cAppInfo).doc(dAppInfoAboutUs).get();
    ourMission = doc.get(fAppInfoOurMission);
    whoAreWe = doc.get(fAppInfoWhoAreWe);
  }

  Future<void> updateCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    imageCacheNumber = 0;
    imageCacheSize = 0;
    if (tempDir.existsSync()) {
      tempDir
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          imageCacheNumber++;
          imageCacheSize += entity.lengthSync() / 1000000; // size in MB
        }
      });
    }
  }

  Future<void> clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    await updateCacheSize();
    notifyListeners();
  }

  Future<void> updateSetting({
    bool newKeepScreenAwake,
    bool newHideRecentRead,
    bool newAllowFollowing,
    bool newRejectStrangerMessage,
    bool newFollowingNotification,
  }) async {
    _logger.i("SettingProvider-updateSetting");
    Map<String, dynamic> data = {};
    if (newKeepScreenAwake != null) {
      keepScreenAwake = data[fSettingScreenAwake] = newKeepScreenAwake;
      Wakelock.toggle(on: newKeepScreenAwake);
    }
    if (newHideRecentRead != null)
      hideRecentRead = data[fSettingHideRecentRead] = newHideRecentRead;
    // if (newAllowFollowing != null)
    //   allowFollowing = data[fSettingAllowFollowing] = newAllowFollowing;
    // if (newRejectStrangerMessage != null)
    //   rejectStrangerMessage =
    //       data[fSettingRejectStrangerMessage] = newRejectStrangerMessage;
    // if (newFollowingNotification != null)
    //   followingNotification =
    //       data[fSettingFollowingNotification] = newFollowingNotification;
    if (data.isNotEmpty) {
      await fdb
          .collection(cUsers)
          .doc(this.userId)
          .collection(cUserProfile)
          .doc(dUserProfileStatic)
          .update(data);
      notifyListeners();
    }
  }
}
