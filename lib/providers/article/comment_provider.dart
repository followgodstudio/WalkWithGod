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
  final DateTime createdDate;
  final String parent;
  final String replyToUid;
  final String replyToName;
  bool like;
  int likesCount;
  int childrenCount; // level 1 comment will have this field
  List<CommentProvider> children = []; // level 1 comment will have this field
  DocumentSnapshot _lastVisibleChild; // level 1 comment will have this field
  bool _noMoreChild = false; // level 1 comment will have this field
  CommentProvider parentPointer; // level 2/3 comment will have this field
  bool _isFetching = false; // To avoid frequently request

  CommentProvider(
      {@required this.id,
      @required this.articleId,
      @required this.content,
      @required this.creatorUid,
      @required this.creatorName,
      @required this.creatorImage,
      @required this.createdDate,
      @required this.likesCount,
      @required this.like,
      this.childrenCount, // level 1 comment will have this field
      this.parent, // level 2/3 comment will have this field
      this.replyToUid, // level 3 comment will have this field
      this.replyToName, // level 3 comment will have this field
      this.parentPointer // level 2/3 comment will have this field
      });

  bool get noMoreChild {
    return _noMoreChild;
  }

  Future<void> fetchL2ChildrenCommentList(String userId,
      [int limit = loadLimit]) async {
    // level 1 comment will call this method
    if (parent != null) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .collection(cArticleCommentReplies)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    children = [];
    _appendL2CommentList(query, userId, limit);
  }

  Future<void> fetchMoreL2ChildrenComments(String userId,
      [int limit = loadLimit]) async {
    // level 1 comment will call this method
    if (parent != null || _noMoreChild || _isFetching) return;
    print("fetch2");
    _isFetching = true;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(id)
        .collection(cArticleCommentReplies)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisibleChild)
        .limit(limit)
        .getDocuments();
    _isFetching = false;
    _appendL2CommentList(query, userId, limit);
  }

  Future<void> addLike(String userId, String userName, String userImage) async {
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
    MessagesProvider().sendMessage(eMessageTypeLike, userId, userName,
        userImage, creatorUid, articleId, parent == null ? id : parent);
    // Change local variables
    like = true;
    likesCount += 1;
    notifyListeners();
  }

  Future<void> cancelLike(String userId) async {
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
          .document(userId)
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
        fCommentReplyLikes: FieldValue.arrayRemove([userId])
      });
    }
    // revoke message???
    like = false;
    likesCount -= 1;
    notifyListeners();
  }

  Future<void> addL2Comment(String l2content, String l2creatorUid,
      String l2creatorName, String l2creatorImage, bool isL3Comment) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = l2content;
    comment[fCommentCreatorUid] = l2creatorUid;
    comment[fCommentCreatorName] = l2creatorName;
    if (l2creatorImage != null) comment[fCommentCreatorImage] = l2creatorImage;
    comment[fCreatedDate] = Timestamp.now();
    comment[fCommentParent] = id;
    comment[fCommentReplyLikes] = [];
    comment[fCommentLikesCount] = 0;
    if (isL3Comment) {
      comment[fCommentReplyToUid] = this.creatorUid;
      comment[fCommentReplyToName] = this.creatorName;
      comment[fCommentParent] = parent;
    }
    // Add a document
    DocumentReference docRef = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(comment[fCommentParent])
        .collection(cArticleCommentReplies)
        .add(comment);
    // Increase parent's children count by 1
    await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(comment[fCommentParent])
        .updateData({fCommentChildrenCount: FieldValue.increment(1)});
    // Send the creator/replyTo a message
    await MessagesProvider().sendMessage(
        eMessageTypeReply,
        l2creatorUid,
        l2creatorName,
        l2creatorImage,
        creatorUid,
        articleId,
        comment[fCommentParent]);
    comment['like'] = false;
    if (isL3Comment) {
      parentPointer._addL2CommentToList(docRef.documentID, comment);
    } else {
      _addL2CommentToList(docRef.documentID, comment);
    }
  }

  void _appendL2CommentList(QuerySnapshot query, String userId, int limit) {
    List<DocumentSnapshot> docs = query.documents;
    if (docs.length < limit) _noMoreChild = true;
    if (docs.length == 0) {
      notifyListeners();
      return;
    }
    query.documents.forEach((data) {
      // Fetch if current user like
      if (data[fCommentReplyLikes] == null) {
        data.data['like'] = false;
      } else {
        data.data['like'] =
            (List<String>.from(data[fCommentReplyLikes])).contains(userId);
      }
      children.add(_buildL2CommentByMap(data.documentID, data.data));
    });
    _lastVisibleChild = query.documents[query.documents.length - 1];
    notifyListeners();
  }

  void _addL2CommentToList(String cid, Map<String, dynamic> data) {
    if (parent != null) return; // Level 2 cannot have children
    children.insert(0, _buildL2CommentByMap(cid, data));
    childrenCount += 1;
    notifyListeners();
  }

  CommentProvider _buildL2CommentByMap(String id, Map<String, dynamic> data) {
    return CommentProvider(
        id: id,
        articleId: data[fCommentArticleId],
        content: data[fCommentContent],
        creatorUid: data[fCommentCreatorUid],
        creatorName: data[fCommentCreatorName],
        creatorImage: data[fCommentCreatorImage],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        parent: data[fCommentParent],
        replyToUid: data[fCommentReplyToUid],
        replyToName: data[fCommentReplyToName],
        childrenCount: data[fCommentChildrenCount],
        likesCount: data[fCommentLikesCount],
        like: data['like'],
        parentPointer: this);
  }
}
