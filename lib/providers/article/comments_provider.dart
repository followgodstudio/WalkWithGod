// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _items = [];
  String _articleId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<CommentProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  // Will be called by comment detail screen
  Future<CommentProvider> fetchLevel1CommentByCommentId(
      String articleId, String commentId, String userId) async {
    // Fetch Comment
    DocumentSnapshot doc = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .doc(commentId)
        .get();
    // Fetch Likes
    DocumentSnapshot docLikes = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .doc(commentId)
        .collection(cArticleCommentLikes)
        .doc(userId)
        .get();
    var tmp = doc.data();
    CommentProvider commentProvider =
        _buildLevel1CommentByMap(commentId, tmp, docLikes.exists);
    return commentProvider;
  }

  Future<void> fetchLevel1CommentListByArticleId(
      String articleId, String userId,
      [int limit = loadLimit]) async {
    if (articleId == null || userId == null) return;
    // Clear data
    _items = [];
    _lastVisible = null;
    _noMore = false;
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    _items = [];
    _articleId = articleId;
    await _appendLevel1CommentList(query, articleId, userId, limit);
  }

  Future<void> fetchMoreLevel1Comments(String userId,
      [int limit = loadLimit]) async {
    if (_articleId == null || userId == null || _noMore || _isFetching) return;
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cArticles)
        .doc(_articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .get();
    await _appendLevel1CommentList(query, _articleId, userId, limit);
  }

  Future<void> addLevel1Comment(String articleId, String content,
      String creatorUid, String creatorName, String creatorImage) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = content;
    comment[fCommentCreatorUid] = creatorUid;
    comment[fCommentCreatorName] = creatorName;
    if (creatorImage != null) comment[fCommentCreatorImage] = creatorImage;
    comment[fCreatedDate] = Timestamp.now();
    comment[fCommentChildrenCount] = 0;
    comment[fCommentLikesCount] = 0;
    DocumentReference docRef = await _db
        .collection(cArticles)
        .doc(articleId)
        .collection(cArticleComments)
        .add(comment);
    _addLevel1CommentToList(docRef.id, comment);
  }

  Future<void> _appendLevel1CommentList(
      QuerySnapshot query, String articleId, String userId, int limit) async {
    List<DocumentSnapshot> docs = query.docs;
    if (docs.length < limit) _noMore = true;
    if (docs.length == 0) {
      notifyListeners();
      return;
    }

    // Fetch if current user like, will it be slow???
    for (int i = 0; i < docs.length; i++) {
      DocumentSnapshot docRef = await _db
          .collection(cArticles)
          .doc(articleId)
          .collection(cArticleComments)
          .doc(docs[i].id)
          .collection(cArticleCommentLikes)
          .doc(userId)
          .get();
      _items.add(
          _buildLevel1CommentByMap(docs[i].id, docs[i].data(), docRef.exists));
    }

    _isFetching = false;
    _lastVisible = query.docs[query.docs.length - 1];
    notifyListeners();
  }

  void _addLevel1CommentToList(String cid, Map<String, dynamic> data) {
    _items.insert(0, _buildLevel1CommentByMap(cid, data, false));
    notifyListeners();
  }

  CommentProvider _buildLevel1CommentByMap(
      String id, Map<String, dynamic> data, bool isLike) {
    return CommentProvider(
        id: id,
        articleId: data[fCommentArticleId],
        content: data[fCommentContent],
        creatorUid: data[fCommentCreatorUid],
        creatorName: data[fCommentCreatorName],
        creatorImage: data[fCommentCreatorImage],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        childrenCount: data[fCommentChildrenCount],
        likesCount: data[fCommentLikesCount],
        like: isLike);
  }
}
