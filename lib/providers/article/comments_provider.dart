import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _items = [];

  List<CommentProvider> get items {
    return [..._items];
  }

  Future<void> fetchL1CommentListByIds(List<String> ids) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cComments)
        .where(FieldPath.documentId, whereIn: ids)
        .getDocuments();
    _setSortL1CommentList(query);
  }

  Future<void> addL1Comment(
      String articleId, String content, String creator) async {
    Map<String, dynamic> comment = {};
    comment[fCommentArticleId] = articleId;
    comment[fCommentContent] = content;
    comment[fCommentCreator] = creator;
    comment[fCreateDate] = Timestamp.now();
    comment[fCommentChildren] = [];
    comment[fCommentLike] = [];
    DocumentReference docRef =
        await Firestore.instance.collection(cComments).add(comment);
    // TODO: add to article comment list
    _addL1CommentToList(docRef.documentID, comment);
  }

  void _setSortL1CommentList(QuerySnapshot query) {
    _items = [];
    query.documents.forEach((data) {
      _items.add(CommentProvider(
          id: data.documentID,
          articleId: data[fCommentArticleId],
          content: data[fCommentContent],
          creator: data[fCommentCreator],
          createDate: (data[fCreateDate] as Timestamp).toDate(),
          children: List<String>.from(data[fCommentChildren]),
          like: List<String>.from(data[fCommentLike])));
    });
    _items.sort((d1, d2) {
      return -d1.createDate.compareTo(d2.createDate);
    });
    notifyListeners();
  }

  void _addL1CommentToList(String cid, Map<String, dynamic> comment) {
    _items.insert(
        0,
        CommentProvider(
            id: cid,
            articleId: comment[fCommentArticleId],
            content: comment[fCommentContent],
            creator: comment[fCommentCreator],
            createDate: (comment[fCreateDate] as Timestamp).toDate(),
            children: List<String>.from(comment[fCommentChildren]),
            like: List<String>.from(comment[fCommentLike])));
    notifyListeners();
  }
}
