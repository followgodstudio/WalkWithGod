import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'message_provider.dart';

class MessagesProvider with ChangeNotifier {
  List<MessageProvider> _items = [];
  String _userId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request

  List<MessageProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  Future<void> fetchMessageListByUid(String userId,
      [int limit = loadLimit]) async {
    if (userId == null) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cUsers)
        .document(userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _items = [];
    _userId = userId;
    _appendMessageList(query, limit);
  }

  Future<void> fetchMoreMessages([int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
    _isFetching = true;
    QuerySnapshot query = await Firestore.instance
        .collection(cUsers)
        .document(_userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .getDocuments();
    _isFetching = false;
    _appendMessageList(query, limit);
  }

  // Used by other classes
  Future<void> sendMessage(
      String type,
      String senderUid,
      String senderName,
      String senderImage,
      String receiverUid,
      String articleId,
      String commentId) async {
    Map<String, dynamic> data = {};
    data[fMessageType] = type;
    data[fMessageSenderUid] = senderUid;
    data[fMessageSenderName] = senderName;
    if (senderImage != null) data[fMessageSenderImage] = senderImage;
    data[fMessageReceiverUid] = receiverUid;
    data[fMessageArticleId] = articleId;
    data[fMessageCommentId] = commentId;
    data[fCreatedDate] = Timestamp.now();
    data[fMessageIsRead] = false;
    // Add document
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .collection(cUserMessages)
        .add(data);
    // Increase message and unread message count by 1
    await Firestore.instance
        .collection(cUsers)
        .document(receiverUid)
        .updateData({
      fUserMessagesCount: FieldValue.increment(1),
      fUserUnreadMsgCount: FieldValue.increment(1)
    });
  }

  void _appendMessageList(QuerySnapshot query, int limit) {
    List<DocumentSnapshot> docs = query.documents;
    docs.forEach((data) {
      _items.add(_buildMessageByMap(data.documentID, data.data));
    });
    if (docs.length < limit) _noMore = true;
    if (docs.length > 0)
      _lastVisible = query.documents[query.documents.length - 1];
    notifyListeners();
  }

  MessageProvider _buildMessageByMap(String id, Map<String, dynamic> data) {
    return MessageProvider(
        id: id,
        articleId: data[fMessageArticleId],
        commentId: data[fMessageCommentId],
        senderUid: data[fMessageSenderUid],
        senderName: data[fMessageSenderName],
        senderImage: data[fMessageSenderImage],
        receiverUid: data[fMessageReceiverUid],
        type: data[fMessageType],
        createDate: (data[fCreatedDate] as Timestamp).toDate(),
        isRead: data[fMessageIsRead]);
  }
}
