import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/Constants.dart';

class UserProvider with ChangeNotifier {
  final String uid;
  Map<String, String> _profile = {};
  List<String> _followers = [];
  List<String> _followings = [];
  List<String> _messages = [];
  List<String> _savedArticles = [];

  UserProvider(this.uid);

  Map<String, String> get profile {
    return _profile;
  }

  List<String> get followers {
    return _followers;
  }

  List<String> get followings {
    return _followings;
  }

  List<String> get messages {
    return _messages;
  }

  List<String> get savedArticles {
    return _savedArticles;
  }

  Future<void> load() async {
    final fStore = Firestore.instance;
    DocumentSnapshot doc =
        await fStore.collection(COLLECTION_USERS).document(uid).get();
    if (doc.data == null) {
      return;
    }
    _profile[FIELD_USER_NAME] = doc.data[FIELD_USER_NAME];
    _profile[FIELD_USER_IMAGEURL] = doc.data[FIELD_USER_IMAGEURL];
    if (doc.data[FIELD_USER_FOLLOWERS] != null)
      _followers = doc.data[FIELD_USER_FOLLOWERS].cast<String>();
    if (doc.data[FIELD_USER_FOLLOWINGS] != null)
      _followings = doc.data[FIELD_USER_FOLLOWINGS].cast<String>();
    if (doc.data[FIELD_USER_MESSAGES] != null)
      _messages = doc.data[FIELD_USER_MESSAGES].cast<String>();
    if (doc.data[FIELD_USER_SAVEDARTICLES] != null)
      _savedArticles = doc.data[FIELD_USER_SAVEDARTICLES].cast<String>();
    notifyListeners();
  }

  Stream<DocumentSnapshot> loadSnap() {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(uid)
        .snapshots();
  }

  Future<void> save() async {
    final fStore = Firestore.instance;
    Map<String, dynamic> data = {};
    data[FIELD_USER_NAME] = _profile[FIELD_USER_NAME];
    data[FIELD_USER_IMAGEURL] = _profile[FIELD_USER_IMAGEURL];
    data[FIELD_USER_FOLLOWERS] = _followers;
    data[FIELD_USER_FOLLOWINGS] = _followings;
    data[FIELD_USER_MESSAGES] = _messages;
    data[FIELD_USER_SAVEDARTICLES] = _savedArticles;
    // updateData can update part of the field, while setData replace all
    await fStore.collection(COLLECTION_USERS).document(uid).updateData(data);
  }
  //TODO: wrtie multiple load and save
  //TODO: upload image
  //TODO: message trigger
}
