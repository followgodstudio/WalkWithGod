import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import '../auth_provider.dart';

class MessagesProvider with ChangeNotifier {
  String _uid;

  void update(AuthProvider auth) {
    if (auth.currentUser != null) {
      _uid = auth.currentUser;
    }
  }

  Stream<QuerySnapshot> getStream() {
    return Firestore.instance
        .collection(cUsers)
        .document(_uid)
        .collection(cUserMessages)
        .snapshots();
  }

  Future<void> add(String type, String fromUID, String aid,
      [String body = ""]) async {
    //TODO: add more field
    //TODO: add to message collections instead
    Map<String, dynamic> data = {};
    data[fUserMessageAid] = aid;
    data[fUserMessageBody] = body;
    data[fUserMessageType] = type;
    data[fUserMessageUid] = fromUID;
    data[fCreateDate] = Timestamp.now();
    Firestore.instance
        .collection(cUsers)
        .document(_uid)
        .collection(cUserMessages)
        .add(data);
  }
}
