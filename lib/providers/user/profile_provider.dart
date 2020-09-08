import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class ProfileProvider with ChangeNotifier {
  String uid;
  String name;
  String imageUrl;
  DateTime createdDate;

  ProfileProvider([this.uid]);

  Stream<Map<String, dynamic>> fetchProfileStream() {
    if (uid == null || uid == "") return null;
    Stream<DocumentSnapshot> stream =
        Firestore.instance.collection(cUsers).document(uid).snapshots();
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

  Future<void> fetchMyProfile() async {
    if (uid == null || uid == "") return;
    DocumentSnapshot doc =
        await Firestore.instance.collection(cUsers).document(uid).get();
    if (doc?.data?.isNotEmpty) {
      name = doc.data[fUserName];
      imageUrl = doc.data[fUserImageUrl];
      createdDate = (doc.data[fCreatedDate] as Timestamp).toDate();
    }
  }

  Future<ProfileProvider> fetchProfileByUid(String userId) async {
    ProfileProvider userProfile = ProfileProvider(userId);
    await userProfile.fetchMyProfile();
    return userProfile;
  }

  Future<void> initProfile(String userId) async {
    uid = userId;
    await Firestore.instance.collection(cUsers).document(uid).setData({});
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
      await Firestore.instance
          .collection(cUsers)
          .document(uid)
          .updateData(data);
      notifyListeners();
    }
  }
}
