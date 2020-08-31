import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';

class MessageProvider with ChangeNotifier {
  final String id;
  final String articleId;
  final String senderUid;
  final String senderName;
  final String senderImage;
  final String receiverUid;
  final String type;
  final DateTime createDate;
  bool isRead;

  MessageProvider({
    @required this.id,
    @required this.articleId,
    @required this.senderUid,
    @required this.senderName,
    @required this.senderImage,
    @required this.receiverUid,
    @required this.type,
    @required this.createDate,
    @required this.isRead,
  });

  Future<void> markMessageAsRead(bool read) async {
    if (isRead == read) return;
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .collection(cUserMessages)
        .document(id)
        .updateData({fMessageIsRead: read});
    isRead = read;
    notifyListeners();
  }
}