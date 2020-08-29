import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'comment_provider.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentProvider> _comments = [];

  List<CommentProvider> get items {
    return [..._comments];
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
    DocumentReference docRef =
        await Firestore.instance.collection(cComments).add(comment);
    // TODO: add to article comment list
    _addL1CommentToList(docRef.documentID, comment);
  }

  void _setSortL1CommentList(QuerySnapshot query) {
    _comments = [];
    query.documents.forEach((data) {
      _comments.add(CommentProvider(
          id: data.documentID,
          articleId: data[fCommentArticleId],
          content: data[fCommentContent],
          creator: data[fCommentCreator],
          createDate: (data[fCreateDate] as Timestamp).toDate(),
          children: List<String>.from(data[fCommentChildren])));
    });
    _comments.sort((d1, d2) {
      return -d1.createDate.compareTo(d2.createDate);
    });
    notifyListeners();
  }

  void _addL1CommentToList(String cid, Map<String, dynamic> comment) {
    _comments.insert(
        0,
        CommentProvider(
            id: cid,
            articleId: comment[fCommentArticleId],
            content: comment[fCommentContent],
            creator: comment[fCommentCreator],
            createDate: (comment[fCreateDate] as Timestamp).toDate(),
            children: List<String>.from(comment[fCommentChildren])));
    notifyListeners();
  }
}
