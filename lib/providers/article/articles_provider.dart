import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'article_provider.dart';

class ArticlesProvider with ChangeNotifier {
  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  Future<void> fetchAll() async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchLatest([int n = 10]) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchList(List<String> aids) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        // .orderBy(FieldPath.documentId)
        // .orderBy(fCreatedDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchArticlesByDate([DateTime dateTime, n = 10]) async {
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  void setArticles(QuerySnapshot query) {
    _articles = [];
    query.documents.forEach((data) {
      Timestamp createdDateTimeStamp = data[fCreatedDate];
      DateTime createdDate = createdDateTimeStamp.toDate();
      _articles.add(ArticleProvider(
          id: data.documentID,
          title: data[fArticleTitle],
          description: data[fArticleDescription],
          imageUrl: data[fArticleImageUrl],
          author: data[fArticleAuthor],
          content: data[fArticleContent],
          createdDate: createdDate,
          icon: data[fArticleIcon]));
    });
    notifyListeners();
  }
}
