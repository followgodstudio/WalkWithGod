import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _items = [];
  String _articleId;
  DocumentSnapshot _lastVisible;
  bool _noMore = false;

  List<CommentProvider> get items {
    return [..._items];
  }

  bool get noMore {
    return _noMore;
  }

  Future<void> fetchL1CommentListByAid(String articleId, String userId,
      [int limit = loadLimit]) async {
    // Restart data
    _items = [];
    _lastVisible = null;
    _noMore = false;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _items = [];
    _articleId = articleId;
    await _appendL1CommentList(query, articleId, userId);
  }

  Future<void> fetchMoreL1Comments(String userId,
      [int limit = loadLimit]) async {
    if (_articleId == null || _noMore) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(_articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .getDocuments();
    await _appendL1CommentList(query, _articleId, userId);
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
      QuerySnapshot query, String articleId, String userId) async {
    List<DocumentSnapshot> docs = query.documents;
    if (docs.length == 0) {
      _noMore = true;
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
