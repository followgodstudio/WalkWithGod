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
    QuerySnapshot query = await Firestore.instance
        .collection(cUsers)
        .document(userId)
        .collection(cUserMessages)
        .getDocuments();
    _setMessageList(query);
  }

  // Used by other classes
  Future<void> sendMessage(String type, String senderUid, String senderName,
      String senderImage, String receiverUid, String articleId) async {
    Map<String, dynamic> data = {};
    data[fMessageArticleId] = articleId;
    data[fMessageType] = type;
    data[fMessageSenderUid] = senderUid;
    data[fMessageSenderName] = senderName;
    data[fMessageSenderImage] = senderImage;
    data[fCreatedDate] = Timestamp.now();
    data[fMessageIsRead] = false;
    // Add document
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .collection(cUserMessages)
        .add(data);
  }

  void _setMessageList(QuerySnapshot query) {
    _items = [];
    query.documents.forEach((data) {
      _items.add(MessageProvider(
          id: data.documentID,
          articleId: data[fMessageArticleId],
          senderUid: data[fMessageSenderUid],
          senderName: data[fMessageSenderName],
          senderImage: data[fMessageSenderImage],
          receiverUid: data[fMessageReceiverUid],
          type: data[fMessageType],
          createDate: (data[fCreatedDate] as Timestamp).toDate(),
          isRead: data[fMessageIsRead]));
    });
    notifyListeners();
  }
}
