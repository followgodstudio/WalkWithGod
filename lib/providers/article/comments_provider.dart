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

  Future<void> fetchL1CommentListByAid(String articleId,
      [int limit = loadLimit]) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .getDocuments();
    _items = [];
    _articleId = articleId;
    _appendL1CommentList(query);
  }

  Future<void> fetchMoreL1Comments([int limit = loadLimit]) async {
    if (_articleId == null) return;
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .document(_articleId)
        .collection(cArticleComments)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(_lastVisible)
        .limit(limit)
        .getDocuments();
    _appendL1CommentList(query);
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
    _addL1CommentToList(docRef.documentID, comment);
  }

  void _appendL1CommentList(QuerySnapshot query) {
    List<DocumentSnapshot> docs = query.documents;
    docs.forEach((data) {
      _items.add(_buildL1CommentByMap(data.documentID, data.data));
    });
    if (docs.length == 0) {
      _noMore = true;
      notifyListeners();
      return;
    }
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
        createDate: (data[fCreatedDate] as Timestamp).toDate(),
        childrenCount: data[fCommentChildrenCount],
        likesCount: data[fCommentLikesCount]);
  }
}
