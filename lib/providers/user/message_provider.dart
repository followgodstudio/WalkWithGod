import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class MessageProvider with ChangeNotifier {
  final String id;
  final String articleId;
  final String commentId;
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
    @required this.commentId,
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
    // Update document
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .collection(cUserMessages)
        .document(id)
        .updateData({fMessageIsRead: read});
    // Update unread count
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .updateData({fUserUnreadMsgCount: FieldValue.increment(-1)});
    isRead = read;
    notifyListeners();
  }
}
