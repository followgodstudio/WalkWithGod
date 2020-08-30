import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _items = [];

  List<CommentProvider> get items {
    return [..._items];
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
    _setL1CommentList(query);
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

  void _setL1CommentList(QuerySnapshot query) {
    _items = [];
    query.documents.forEach((data) {
      _items.add(CommentProvider(
          id: data.documentID,
          articleId: data[fCommentArticleId],
          content: data[fCommentContent],
          creatorUid: data[fCommentCreatorUid],
          creatorName: data[fCommentCreatorName],
          creatorImage: data[fCommentCreatorImage],
          createDate: (data[fCreatedDate] as Timestamp).toDate(),
          childrenCount: data[fCommentChildrenCount],
          likesCount: data[fCommentLikesCount]));
    });
    notifyListeners();
  }

  void _addL1CommentToList(String cid, Map<String, dynamic> data) {
    _items.insert(
        0,
        CommentProvider(
            id: cid,
            articleId: data[fCommentArticleId],
            content: data[fCommentContent],
            creatorUid: data[fCommentCreatorUid],
            creatorName: data[fCommentCreatorName],
            creatorImage: data[fCommentCreatorImage],
            createDate: (data[fCreatedDate] as Timestamp).toDate(),
            childrenCount: data[fCommentChildrenCount],
            likesCount: data[fCommentLikesCount]));
    notifyListeners();
  }
}
