import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import 'message_provider.dart';

class MessagesProvider with ChangeNotifier {
  List<MessageProvider> _items = [];
  String _userId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<MessageProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  Future<void> fetchMessageListByUid(String userId,
      [int limit = loadLimit]) async {
    if (userId == null) return;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    _items = [];
    _userId = userId;
    _appendMessageList(query, limit);
  }

  Future<void> fetchMoreMessages([int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserMessages)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .get();
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

    WriteBatch batch = _db.batch();

    // Add document
    var newDocRef =
        _db.collection(cUsers).doc(receiverUid).collection(cUserMessages).doc();
    batch.set(newDocRef, data);
    // Increase message and unread message count by 1
    batch.update(_db.collection(cUsers).doc(receiverUid), {
      fUserMessagesCount: FieldValue.increment(1),
      fUserUnreadMsgCount: FieldValue.increment(1)
    });

    await batch.commit();
  }

  void _appendMessageList(QuerySnapshot query, int limit) {
    List<DocumentSnapshot> docs = query.docs;
    docs.forEach((data) {
      _items.add(_buildMessageByMap(data.id, data.data()));
    });
    if (docs.length < limit) _noMore = true;
    if (docs.length > 0) _lastVisible = query.docs[query.docs.length - 1];
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
