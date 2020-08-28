import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import './ArticleProvider.dart';
import '../../model/Constants.dart';

class ArticlesProvider with ChangeNotifier {
  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return _articles;
  }

  Future<void> fetchAll() async {
    QuerySnapshot query = await Firestore.instance
        .collection(C_ARTICLES)
        .orderBy(F_CREATE_DATE, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchLatest(int n) async {
    QuerySnapshot query = await Firestore.instance
        .collection(C_ARTICLES)
        .orderBy(F_CREATE_DATE, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchList(List<String> aids) async {
    QuerySnapshot query = await Firestore.instance
        .collection(C_ARTICLES)
        .where('id', whereIn: aids)
        .orderBy(F_CREATE_DATE, descending: true)
        .getDocuments();
    setArticles(query);
  }

  void setArticles(QuerySnapshot query) {
    _articles = [];
    query.documents.forEach((element) {
      _articles.add(ArticleProvider(element.documentID, element.data));
    });
    notifyListeners();
  }
}
