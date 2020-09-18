import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock/wakelock.dart';

import '../../configurations/constants.dart';

class SettingProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String uid;
  bool keepScreenAwakeOnRead = false;
  bool hideRecentRead = false;
  bool allowFollowing = false;
  bool rejectStrangerMessage = false;
  List<String> blackList = [];
  bool followingNotification = false;
  String ourMission = "";
  String whoAreWe = "";

  SettingProvider();

  Future<void> fetchSetting(String userId) async {
    if (userId == null || userId == "") uid = userId;
  }

  Future<void> fetchAppInfo() async {
    DocumentSnapshot doc = await _db.collection(cAppInfo).doc(dAboutUs).get();
    ourMission = doc.get(fOurMission);
    whoAreWe = doc.get(fWhoAreWe);
  }

  Future<void> updateSetting({
    bool newKeepScreenAwakeOnRead,
    bool newHideRecentRead,
    bool newAllowFollowing,
    bool newRejectStrangerMessage,
    bool newFollowingNotification,
  }) async {
    Map<String, dynamic> data = {};
    if (newKeepScreenAwakeOnRead != null) {
      keepScreenAwakeOnRead =
          data[fSettingScreenAwake] = newKeepScreenAwakeOnRead;
      Wakelock.toggle(on: newKeepScreenAwakeOnRead);
    }
    if (newHideRecentRead != null)
      hideRecentRead = data[fSettingHideRecentRead] = newHideRecentRead;
    if (newAllowFollowing != null)
      allowFollowing = data[fSettingAllowFollowing] = newAllowFollowing;
    if (newRejectStrangerMessage != null)
      rejectStrangerMessage =
          data[fSettingRejectStrangerMessage] = newRejectStrangerMessage;
    if (newFollowingNotification != null)
      followingNotification =
          data[fSettingFollowingNotification] = newFollowingNotification;
    if (data.isNotEmpty) {
      print(data);
      // await _db.collection(cUsers).document(uid).updateData(data);
      notifyListeners();
    }
  }
}
