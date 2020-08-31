import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';

class ProfileProvider with ChangeNotifier {
  String uid;
  String name;
  String imageUrl;
  DateTime createdDate;

  Future<void> fetchProfileByUid(String userId) async {
    DocumentSnapshot doc =
        await Firestore.instance.collection(cUsers).document(userId).get();
    if (doc?.data?.isNotEmpty) {
      uid = userId;
      name = doc.data[fUserName];
      imageUrl = doc.data[fUserImageUrl];
      createdDate = (doc.data[fCreatedDate] as Timestamp).toDate();
      notifyListeners();
    }
  }

  Future<void> initProfile(String userId) async {
    uid = userId;
    await Firestore.instance.collection(cUsers).document(uid).setData({});
    String newName = "弟兄姐妹"; // TODO: Random name
    String defaultUrl = "https://photo.sohu.com/88/60/Img214056088.jpg";
    await updateProfile(
        newName: newName,
        newImageUrl: defaultUrl,
        newCreatedDate: Timestamp.now());
  }

  Future<void> updateProfile(
      {String newName, String newImageUrl, Timestamp newCreatedDate}) async {
    Map<String, dynamic> data = {};
    if (newName != null) name = data[fUserName] = newName;
    if (newImageUrl != null) imageUrl = data[fUserImageUrl] = newImageUrl;
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
