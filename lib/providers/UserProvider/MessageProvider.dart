import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/Constants.dart';

class MessageProvider with ChangeNotifier {
  final String uid;
  List<dynamic> _messages = [];

  MessageProvider(this.uid);

  Future<void> load() async {
    final fStore = Firestore.instance;
    QuerySnapshot doc = await fStore
        .collection(COLLECTION_USERS)
        .document(uid)
        .collection(COLLECTION_USER_MESSAGES)
        .getDocuments();
    _messages = doc.documents;
    print(_messages);
    notifyListeners();
  }

  Stream<QuerySnapshot> getStream() {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(uid)
        .collection('messages')
        .snapshots();
  }

  Future<void> save() async {
    final fStore = Firestore.instance;
    Map<String, dynamic> data = {};
    // updateData can update part of the field, while setData replace all
    await fStore.collection(COLLECTION_USERS).document(uid).updateData(data);
  }
  //TODO: wrtie multiple load and save
  //TODO: upload image
  //TODO: message trigger
}
