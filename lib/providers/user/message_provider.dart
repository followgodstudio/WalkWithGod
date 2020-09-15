import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
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
    isRead = read;
    notifyListeners();

    // Update document
    WriteBatch batch = _db.batch();
    batch.update(
        _db
            .collection(cUsers)
            .doc(receiverUid)
            .collection(cUserMessages)
            .doc(id),
        {fMessageIsRead: read});
    // Update unread count
    batch.update(_db.collection(cUsers).doc(receiverUid),
        {fUserUnreadMsgCount: FieldValue.increment(-1)});
    await batch.commit();
  }
}
