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
        .orderBy(fCreateDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchLatest([int n = 10]) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .orderBy(fCreateDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchList(List<String> aids) async {
    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        // .orderBy(FieldPath.documentId)
        // .orderBy(fCreateDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchArticlesByDate([DateTime dateTime, n = 10]) async {
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await Firestore.instance
        .collection(cArticles)
        .where(fCreateDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreateDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  void setArticles(QuerySnapshot query) {
    _articles = [];
    query.documents.forEach((data) {
      Timestamp createdDateTimeStamp = data[fCreateDate];
      DateTime createdDate = createdDateTimeStamp.toDate();
      _articles.add(ArticleProvider(
          id: data.documentID,
          title: data['title'],
          description: data['description'],
          imageUrl: data['image_url'],
          author: data['author'],
          content: data['content'],
          createdDate: createdDate,
          icon: data['icon']));
    });
    notifyListeners();
  }
}
