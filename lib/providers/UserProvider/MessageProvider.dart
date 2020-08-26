import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/Constants.dart';

class MessageProvider with ChangeNotifier {
  final String uid;
  MessageProvider(this.uid);

  Stream<QuerySnapshot> getStream() {
    return Firestore.instance
        .collection(C_USERS)
        .document(uid)
        .collection(C_USER_MESSAGES)
        .snapshots();
  }

  Future<void> add(String type, String fromUID, String aid,
      [String body = ""]) async {
    //TODO: add more field
    Map<String, dynamic> data = {};
    data[F_USER_MESSAGE_AID] = aid;
    data[F_USER_MESSAGE_BODY] = body;
    data[F_USER_MESSAGE_TYPE] = type;
    data[F_USER_MESSAGE_UID] = fromUID;
    data[F_CREATE_DATE] = Timestamp.now();
    Firestore.instance
        .collection(C_USERS)
        .document(uid)
        .collection(C_USER_MESSAGES)
        .add(data);
  }
}
