import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
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
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    QuerySnapshot query = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .doc(id)
        .collection(cArticleCommentReplies)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    children = [];
    _appendL2CommentList(query, userId, limit);
  }

  Future<void> fetchMoreL2ChildrenComments(String userId,
      [int limit = loadLimit]) async {
    // level 1 comment will call this method
    if (parent != null || _noMoreChild || _isFetching) return;
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .doc(id)
        .collection(cArticleCommentReplies)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisibleChild)
        .limit(limit)
        .get();
    _isFetching = false;
    _appendL2CommentList(query, userId, limit);
  }

  Future<void> addLike(String userId, String userName, String userImage) async {
    // Change local variables
    like = true;
    likesCount += 1;
    notifyListeners();

    // Add user to like list
    if (parent == null) {
      // Level 1
      WriteBatch batch = _db.batch();
      // Add a document
      batch.set(
          _db
              .collection(cArticles)
              .doc(articleId)
              .collection(cArticleComments)
              .doc(id)
              .collection(cArticleCommentLikes)
              .doc(userId),
          {});
      // Increase like count by 1
      batch.update(
          _db
              .collection(cArticles)
              .doc(articleId)
              .collection(cArticleComments)
              .doc(id),
          {fCommentLikesCount: FieldValue.increment(1)});
      await batch.commit();
    } else {
      // Level 2
      await _db
          .collection(cArticles)
          .doc(articleId)
          .collection(cArticleComments)
          .doc(parent)
          .collection(cArticleCommentReplies)
          .doc(id)
          .update({
        fCommentLikesCount: FieldValue.increment(1),
        fCommentReplyLikes: FieldValue.arrayUnion([userId])
      });
    }
    // Send the creator a message
    await MessagesProvider().sendMessage(eMessageTypeLike, userId, userName,
        userImage, creatorUid, articleId, parent == null ? id : parent);
  }

  Future<void> cancelLike(String userId) async {
    // revoke message???
    like = false;
    likesCount -= 1;
    notifyListeners();

    // Remove user from like list
    if (parent == null) {
      // Level 1
      WriteBatch batch = _db.batch();
      // Remove a document
      batch.delete(_db
          .collection(cArticles)
          .doc(articleId)
          .collection(cArticleComments)
          .doc(id)
          .collection(cArticleCommentLikes)
          .doc(userId));
      // Decrease like count by 1
      batch.update(
          _db
              .collection(cArticles)
              .doc(articleId)
              .collection(cArticleComments)
              .doc(id),
          {fCommentLikesCount: FieldValue.increment(-1)});
      await batch.commit();
    } else {
      // Level 2
      await _db
          .collection(cArticles)
          .doc(articleId)
          .collection(cArticleComments)
          .doc(parent)
          .collection(cArticleCommentReplies)
          .doc(id)
          .update({
        fCommentLikesCount: FieldValue.increment(-1),
        fCommentReplyLikes: FieldValue.arrayRemove([userId])
      });
    }
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

    WriteBatch batch = _db.batch();
    // Add a document
    DocumentReference newDocRef = _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .doc(comment[fCommentParent])
        .collection(cArticleCommentReplies)
        .doc();
    batch.set(newDocRef, comment);
    // Increase parent's children count by 1
    batch.update(
        _db
            .collection(cArticles)
            .doc(articleId)
            .collection(cArticleComments)
            .doc(comment[fCommentParent]),
        {fCommentChildrenCount: FieldValue.increment(1)});
    await batch.commit();

    // Update local variables
    comment['like'] = false;
    if (isL3Comment) {
      parentPointer._addL2CommentToList(newDocRef.id, comment);
    } else {
      _addL2CommentToList(newDocRef.id, comment);
    }

    // Send the creator/replyTo a message
    await MessagesProvider().sendMessage(
        eMessageTypeReply,
        l2creatorUid,
        l2creatorName,
        l2creatorImage,
        creatorUid,
        articleId,
        comment[fCommentParent]);
  }

  void _appendL2CommentList(QuerySnapshot query, String userId, int limit) {
    List<DocumentSnapshot> docs = query.docs;
    //docs[0].data().update(key, (value) => null)
    if (docs.length < limit) _noMoreChild = true;
    if (docs.length == 0) {
      notifyListeners();
      return;
    }
    query.docs.forEach((doc) {
      // Fetch if current user like

      var copyOfData = doc.data();

      if (doc.data().containsKey(fCommentReplyLikes)) {
        if (doc.data() != null) {
          copyOfData.update('like', (value) => false, ifAbsent: () => false);
          copyOfData.update('id', (value) => doc.id, ifAbsent: () => doc.id);
        }

        //doc.data().update('like', (value) => false, ifAbsent: () => false);
      } else {
        if (doc.data() != null) {
          copyOfData.update('like', (_) {
            return (List<String>.from(doc.get(fCommentReplyLikes)))
                .contains(userId);
          }, ifAbsent: () => false);
          copyOfData.update('id', (value) => doc.id, ifAbsent: () => doc.id);
        }
        // doc.data().update("like", (_) {
        //   return (List<String>.from(doc.get(fCommentReplyLikes)))
        //       .contains(userId);
        // }, ifAbsent: () => false);
        // data.data['like'] =
        //     (List<String>.from(doc.[fCommentReplyLikes])).contains(userId);
      }
      children.add(_buildL2CommentByMap(doc.id, copyOfData));
    });
    _lastVisibleChild = query.docs[query.docs.length - 1];
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
