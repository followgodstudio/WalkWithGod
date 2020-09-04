import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';
import 'article_provider.dart';

class ArticlesProvider with ChangeNotifier {
  var _fdb = Firestore.instance;
  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  Future<void> fetchAll() async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchLatest([int n = 10]) async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchList(List<String> aids) async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        // .orderBy(FieldPath.documentId)
        // .orderBy(fCreatedDate, descending: true)
        .getDocuments();
    setArticles(query);
  }

  Future<void> fetchArticlesByDate(
      [DateTime dateTime, int n = 10, bool isContentNeeded = false]) async {
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .getDocuments();
    setArticles(query, isContentNeeded);
  }

  void setArticles(QuerySnapshot query, [bool isContentNeeded = false]) {
    _articles = [];
    query.documents.forEach((data) {
      _articles.add(_buildArticleByMap(data.documentID, data.data));
    });

    notifyListeners();
  }

  Future<void> fetchArticleConentById(String aid) async {
    List<Paragraph> content = [];
    await _fdb
        .collection(cArticles)
        .document(aid)
        .collection(cArticleContent)
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot != null) {
        querySnapshot.documents.forEach((element) {
          content.add(Paragraph(
              subtitle: element.data[fContentSubtitle],
              body: element.data[fContentBody]));
        });

        _articles.firstWhere((a) => a.id == aid).content = content;
      }
    }).catchError((error) {
      throw (error);
    });

    notifyListeners();
    //return _content;
  }

  Future<ArticleProvider> fetchArticlePreviewById(String aid) async {
    DocumentSnapshot data =
        await _fdb.collection(cArticles).document(aid).get();
    return _buildArticleByMap(data.documentID, data.data);
  }

  ArticleProvider findById(String id) {
    return _articles.firstWhere((a) => a.id == id);
  }

  ArticleProvider _buildArticleByMap(String id, Map<String, dynamic> data) {
    return ArticleProvider(
        id: id,
        title: data[fArticleTitle],
        description: data[fArticleDescription],
        imageUrl: data[fArticleImageUrl],
        author: data[fArticleAuthorName],
        createdDate: (data[fCreatedDate] as Timestamp).toDate(),
        icon: data[fArticleIcon],
        publisher: data[fArticlePublisher]);
  }
}
