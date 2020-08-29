import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';

class MessageProvider with ChangeNotifier {
  final String id;
  final String articleId;
  final String creator;
  final String receiver;
  final String type;
  final DateTime createDate;
  bool isRead;
  final String content;

  MessageProvider({
    @required this.id,
    @required this.articleId,
    @required this.creator,
    @required this.receiver,
    @required this.type,
    @required this.createDate,
    @required this.isRead,
    this.content,
  });

  Future<void> markMessageAsRead(bool read) async {
    if (isRead == read) return;
    await Firestore.instance
        .collection(cMessages)
        .document(id)
        .updateData({fMessageIsRead: read});
    isRead = read;
    notifyListeners();
  }
}
