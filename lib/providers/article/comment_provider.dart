import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import '../user/messages_provider.dart';

class CommentProvider with ChangeNotifier {
  final String id;
  final String articleId;
  final String content;
  final String creatorUid;
  final String creatorName;
  final String creatorImage;
  final DateTime createDate;
  final String parent;
  final String replyTo;
  int likesCount;
  int childrenCount; // level 1 comment will have this field
  List<String> likes = [];
  List<CommentProvider> children = []; // level 1 comment will have this field

  CommentProvider({
    @required this.id,
    @required this.articleId,
    @required this.content,
    @required this.creatorUid,
    @required this.creatorName,
    @required this.creatorImage,
    @required this.createDate,
    @required this.likesCount,
    this.childrenCount, // level 1 comment will have this field
    this.parent, // level 2/3 comment will have this field
    this.likes, // level 2/3 comment will have this field
    this.replyTo, // level 3 comment will have this field
  });

  Future<void> fetchL2ChildrenCommentList([int limit = loadLimit]) async {
    if (children == []) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .collection(cArticleCommentReplies)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _setL2CommentList(query);
  }

  Future<void> fetchLikes() async {
    // Only used for level 1 comment, level 2 will be fetched automatically
    if (likes == null) likes = [];
    if (likesCount == likes.length) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .collection(cArticleCommentLikes)
        .getDocuments();
    likes = query.documents.map((doc) => doc.documentID).toList();
  }

  Future<void> addLike(String userId, String userName, String userImage) async {
    await fetchLikes();
    if (likes.contains(userId)) return;
    // Add user to like list
    if (parent == null) {
      // Level 1
      // Add a document
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(id)
          .collection(cArticleCommentLikes)
          .document(userId)
          .setData({});
      // Increase like count by 1
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(id)
          .updateData({fCommentLikesCount: FieldValue.increment(1)});
    } else {
      // Level 2
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(parent)
          .collection(cArticleCommentReplies)
          .document(id)
          .updateData({
        fCommentLikesCount: FieldValue.increment(1),
        fCommentReplyLikes: FieldValue.arrayUnion([userId])
      });
    }
    // Send the creator a message
    MessagesProvider().sendMessage(
        eMessageTypeLike, userId, userName, userImage, creatorUid, articleId);
    // Change local variables
    likes.add(userId);
    likesCount += 1;
    notifyListeners();
  }

  Future<void> cancelLike(String user) async {
    await fetchLikes();
    if (!likes.contains(user)) return;
    // Remove user from like list
    if (parent == null) {
      // Level 1
      // Remove a document
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(id)
          .collection(cArticleCommentLikes)
          .document(user)
          .delete();
      // Decrease like count by 1
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(id)
          .updateData({fCommentLikesCount: FieldValue.increment(-1)});
    } else {
      // Level 2
      await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(parent)
          .collection(cArticleCommentReplies)
          .document(id)
          .updateData({
        fCommentLikesCount: FieldValue.increment(-1),
        fCommentReplyLikes: FieldValue.arrayRemove([user])
      });
    }
    // revoke message?
    likes.remove(user);
    likesCount -= 1;
    notifyListeners();
  }

  Future<void> addL2Comment(String l2content, String l2creatorUid,
      String l2creatorName, String l2creatorImage,
      [String l2replyTo]) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = l2content;
    comment[fCommentCreatorUid] = l2creatorUid;
    comment[fCommentCreatorName] = l2creatorName;
    comment[fCommentCreatorImage] = l2creatorImage;
    comment[fCreatedDate] = Timestamp.now();
    comment[fCommentParent] = id;
    comment[fCommentReplyLikes] = [];
    comment[fCommentLikesCount] = 0;
    if (l2replyTo != null)
      // This is a third level comment
      comment[fCommentReplyTo] = l2replyTo;
    // Add a document
    DocumentReference docRef = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .collection(cArticleCommentReplies)
        .add(comment);
    // Increase parent's children count by 1
    await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .updateData({fCommentChildrenCount: FieldValue.increment(1)});
    // Send the creator/replyTo a message
    String receiver = (l2replyTo == null) ? creatorUid : l2replyTo;
    MessagesProvider().sendMessage(eMessageTypeReply, l2creatorUid,
        l2creatorName, l2creatorImage, receiver, articleId);
    _addL2CommentToList(docRef.documentID, comment);
  }

  void _setL2CommentList(QuerySnapshot query) {
    children = [];
    query.documents.forEach((data) {
      children.add(CommentProvider(
          id: data.documentID,
          articleId: data[fCommentArticleId],
          content: data[fCommentContent],
          creatorUid: data[fCommentCreatorUid],
          creatorName: data[fCommentCreatorName],
          creatorImage: data[fCommentCreatorImage],
          createDate: (data[fCreatedDate] as Timestamp).toDate(),
          parent: data[fCommentParent],
          replyTo: data[fCommentReplyTo],
          childrenCount: data[fCommentChildrenCount],
          likes: List<String>.from(data[fCommentReplyLikes]),
          likesCount: data[fCommentLikesCount]));
    });
    notifyListeners();
  }

  void _addL2CommentToList(String cid, Map<String, dynamic> data) {
    if (parent != null) return; // Level 2 cannot have children
    children.insert(
        0,
        CommentProvider(
            id: cid,
            articleId: data[fCommentArticleId],
            content: data[fCommentContent],
            creatorUid: data[fCommentCreatorUid],
            creatorName: data[fCommentCreatorName],
            creatorImage: data[fCommentCreatorImage],
            createDate: (data[fCreatedDate] as Timestamp).toDate(),
            parent: data[fCommentParent],
            replyTo: data[fCommentReplyTo],
            childrenCount: data[fCommentChildrenCount],
            likes: List<String>.from(data[fCommentReplyLikes]),
            likesCount: data[fCommentLikesCount]));
    childrenCount += 1;
    notifyListeners();
  }
}
