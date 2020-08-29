import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import '../user/messages_provider.dart';

class CommentProvider with ChangeNotifier {
  final String id;
  final String articleId;
  final String content;
  final String creator;
  final DateTime createDate;
  final String parent;
  final String replyTo;
  List<String> like = [];
  List<String> children = [];
  List<CommentProvider> childrenList = [];

  CommentProvider({
    @required this.id,
    @required this.articleId,
    @required this.content,
    @required this.creator,
    @required this.createDate,
    @required this.like,
    this.children, // level 1 comment will have this field
    this.parent, // level 2 comment will have this field
    this.replyTo, // level 3 comment will have this field
  });

  Future<void> fetchL2ChildrenCommentList() async {
    if (children == []) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cComments)
        .where(FieldPath.documentId, whereIn: children)
        .getDocuments();
    _setSortL2CommentList(query);
  }

  Future<void> addLike(String user) async {
    if (like.contains(user)) return;
    // Add user to like list
    await Firestore.instance.collection(cComments).document(id).setData({
      fCommentLike: FieldValue.arrayUnion([user])
    }, merge: true);
    // Send the creator a message
    MessagesProvider().sendMessage(eMessageTypeLike, user, creator, articleId);
    like.add(user);
    notifyListeners();
  }

  Future<void> cancelLike(String user) async {
    if (!like.contains(user)) return;
    // Add user to like list
    await Firestore.instance.collection(cComments).document(id).setData({
      fCommentLike: FieldValue.arrayRemove([user])
    }, merge: true);
    // revoke message?
    like.remove(user);
    notifyListeners();
  }

  Future<void> addL2Comment(String l2content, String l2creator,
      [String l2replyTo]) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = l2content;
    comment[fCommentCreator] = l2creator;
    comment[fCreateDate] = Timestamp.now();
    comment[fCommentParent] = id;
    comment[fCommentLike] = [];
    if (l2replyTo != null)
      // This is a third level comment
      comment[fCommentReplyTo] = l2replyTo;
    DocumentReference docRef =
        await Firestore.instance.collection(cComments).add(comment);
    // Add returned cid in parent's children list
    await Firestore.instance.collection(cComments).document(id).setData({
      fCommentChildren: FieldValue.arrayUnion([docRef.documentID])
    }, merge: true);
    // Send the creator/replyTo a message
    String receiver = (l2replyTo == null) ? creator : l2replyTo;
    MessagesProvider().sendMessage(
        eMessageTypeReply, l2creator, receiver, articleId, l2content);
    _addL2CommentToList(docRef.documentID, comment);
  }

  void _setSortL2CommentList(QuerySnapshot query) {
    childrenList = [];
    query.documents.forEach((data) {
      childrenList.add(CommentProvider(
          id: data.documentID,
          articleId: data[fCommentArticleId],
          content: data[fCommentContent],
          creator: data[fCommentCreator],
          createDate: (data[fCreateDate] as Timestamp).toDate(),
          parent: data[fCommentParent],
          replyTo: data[fCommentReplyTo],
          like: List<String>.from(data[fCommentLike])));
    });
    childrenList.sort((d1, d2) {
      return -d1.createDate.compareTo(d2.createDate);
    });
    notifyListeners();
  }

  void _addL2CommentToList(String cid, Map<String, dynamic> comment) {
    children.insert(0, cid);
    childrenList.insert(
        0,
        CommentProvider(
            id: cid,
            articleId: comment[fCommentArticleId],
            content: comment[fCommentContent],
            creator: comment[fCommentCreator],
            createDate: (comment[fCreateDate] as Timestamp).toDate(),
            parent: comment[fCommentParent],
            replyTo: comment[fCommentReplyTo],
            like: List<String>.from(comment[fCommentLike])));
    notifyListeners();
  }
}
