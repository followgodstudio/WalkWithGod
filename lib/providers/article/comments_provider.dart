import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _items = [];
  String _articleId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;
  bool _isFetching = false; // To avoid frequently request

  List<CommentProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  Future<CommentProvider> fetchL1CommentByCid(
      String articleId, String commentId, String userId) async {
    // Fetch Comment
    DocumentSnapshot doc = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(commentId)
        .get();
    // Fetch Likes
    DocumentSnapshot docLikes = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .document(commentId)
        .collection(cArticleCommentLikes)
        .document(userId)
        .get();
    doc.data['like'] = docLikes.exists;
    CommentProvider commentProvider = _buildL1CommentByMap(commentId, doc.data);
    // Fetch it children list
    await commentProvider.fetchL2ChildrenCommentList(userId);
    return commentProvider;
  }

  Future<void> fetchL1CommentListByAid(String articleId, String userId,
      [int limit = loadLimit]) async {
    if (articleId == null || userId == null) return;
    // Clear data
    _items = [];
    _lastVisible = null;
    _noMore = false;
    _isFetching = true;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _items = [];
    _articleId = articleId;
    await _appendL1CommentList(query, articleId, userId, limit);
  }

  Future<void> fetchMoreL1Comments(String userId,
      [int limit = loadLimit]) async {
    if (_articleId == null || userId == null || _noMore || _isFetching) return;
    print("fetch1");
    _isFetching = true;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(_articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .getDocuments();
    await _appendL1CommentList(query, _articleId, userId, limit);
  }

  Future<void> addL1Comment(String articleId, String content, String creatorUid,
      String creatorName, String creatorImage) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = content;
    comment[fCommentCreatorUid] = creatorUid;
    comment[fCommentCreatorName] = creatorName;
    comment[fCommentCreatorImage] = creatorImage;
    comment[fCreatedDate] = Timestamp.now();
    comment[fCommentChildrenCount] = 0;
    comment[fCommentLikesCount] = 0;
    DocumentReference docRef = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .add(comment);
    comment['like'] = false;
    _addL1CommentToList(docRef.documentID, comment);
  }

  Future<void> _appendL1CommentList(
      QuerySnapshot query, String articleId, String userId, int limit) async {
    List<DocumentSnapshot> docs = query.documents;
    if (docs.length < limit) _noMore = true;
    if (docs.length == 0) {
      notifyListeners();
      return;
    }
    // Fetch if current user like, will it be slow???
    for (int i = 0; i < docs.length; i++) {
      DocumentSnapshot docRef = await Firestore.instance
          .collection(cArticles)
          .document(articleId)
          .collection(cArticleComments)
          .document(docs[i].documentID)
          .collection(cArticleCommentLikes)
          .document(userId)
          .get();
      docs[i].data['like'] = docRef.exists;
    }
    _isFetching = false;
    docs.forEach((data) {
      _items.add(_buildL1CommentByMap(data.documentID, data.data));
    });
    _lastVisible = query.documents[query.documents.length - 1];
    notifyListeners();
  }

  void _addL1CommentToList(String cid, Map<String, dynamic> data) {
    _items.insert(0, _buildL1CommentByMap(cid, data));
    notifyListeners();
  }

  CommentProvider _buildL1CommentByMap(String id, Map<String, dynamic> data) {
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
        like: data['like']);
  }
}
