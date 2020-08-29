import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'message_provider.dart';

class MessagesProvider with ChangeNotifier {
  List<MessageProvider> _items = [];

  List<MessageProvider> get items {
    return [..._items];
  }

  // TODO: For dynamic message update
  Stream<QuerySnapshot> fetchStreamByIds(String uid) {
    return Firestore.instance
        .collection(cUsers)
        .document(uid)
        .collection(cUserMessages)
        .snapshots();
  }

  Future<void> fetchMessageListByUserId(String userId) async {
    // Fetch user message list
    QuerySnapshot query1 = await Firestore.instance
        .collection(cUsers)
        .document(userId)
        .collection(cUserMessages)
        .getDocuments();
    List<String> mids =
        query1.documents.map((item) => item.documentID).toList();
    QuerySnapshot query2 = await Firestore.instance
        .collection(cMessages)
        .where(FieldPath.documentId, whereIn: mids)
        .getDocuments();
    _setSortMessageList(query2);
  }

  // Used by other classes
  Future<void> sendMessage(
      String type, String creator, String receiver, String articleId,
      [String content = ""]) async {
    Map<String, dynamic> data = {};
    data[fMessageArticleId] = articleId;
    data[fMessageType] = type;
    data[fMessageCreator] = creator;
    data[fMessageReceiver] = receiver;
    data[fCreateDate] = Timestamp.now();
    data[fMessageIsRead] = false;
    if (content != null) data[fMessageContent] = content;
    // Add Message to message collection
    DocumentReference docRef =
        await Firestore.instance.collection(cMessages).add(data);
    // Add message key to receiver's message list
    await Firestore.instance
        .collection(cUsers)
        .document(receiver)
        .collection(cUserMessages)
        .document(docRef.documentID)
        .setData({});
  }

  void _setSortMessageList(QuerySnapshot query) {
    _items = [];
    query.documents.forEach((data) {
      _items.add(MessageProvider(
          id: data.documentID,
          articleId: data[fMessageArticleId],
          content: data[fMessageContent],
          creator: data[fMessageCreator],
          receiver: data[fMessageReceiver],
          type: data[fMessageType],
          createDate: (data[fCreateDate] as Timestamp).toDate(),
          isRead: data[fMessageIsRead]));
    });
    _items.sort((d1, d2) {
      return -d1.createDate.compareTo(d2.createDate);
    });
    notifyListeners();
  }
}
