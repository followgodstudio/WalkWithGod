import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
//import 'package:the_gorgeous_login/configurations/constants.dart';

import '../../configurations/constants.dart';
import 'article_provider.dart';

class ArticlesProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  String uid;

  ArticlesProvider([this.uid]);

  List<ArticleProvider> _articles = [];

  List<ArticleProvider> get articles {
    return [..._articles];
  }

  Future<void> fetchAll() async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .get();
    setArticles(query);
  }

  Future<void> fetchLatest([int n = 10]) async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .get();
    setArticles(query);
  }

  // For other providers static call
  Future<List<ArticleProvider>> fetchList(List<String> aids) async {
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(FieldPath.documentId, whereIn: aids)
        .get();
    List<ArticleProvider> result = [];
    query.docs.forEach((data) {
      result.add(_buildArticleByMap(data.id, data.data()));
    });
    return result;
  }

  Future<void> fetchArticlesByDate(
      [DateTime dateTime, int n = 10, bool isContentNeeded = false]) async {
    print("bp2");
    if (dateTime == null) dateTime = DateTime.now();

    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fCreatedDate, isGreaterThanOrEqualTo: dateTime)
        .orderBy(fCreatedDate, descending: true)
        .limit(n)
        .get();
    setArticles(query, isContentNeeded);
  }

  void setArticles(QuerySnapshot query, [bool isContentNeeded = false]) {
    _articles = [];
    query.docs.forEach((data) {
      _articles.add(_buildArticleByMap(data.id, data.data()));
    });

    notifyListeners();
  }

  Future<void> fetchArticleConentById(String aid) async {
    List<Paragraph> content = [];
    QuerySnapshot querySnapshot = await _fdb
        .collection(cArticles)
        .doc(aid)
        .collection(cArticleContent)
        .orderBy(fContentIndex)
        .get();
    if (querySnapshot != null) {
      querySnapshot.docs.forEach((element) {
        var subtitle = "";
        try {
          subtitle = element.get(fContentSubtitle);
        } catch (err) {
          print("subtitle does not exist");
        }
        content.add(
            Paragraph(subtitle: subtitle, body: element.get(fContentBody)));
      });
      ArticleProvider article =
          _articles.firstWhere((a) => a.id == aid, orElse: () {
        return null;
      });
      if (article != null) article.content = content;
    }
  }

  Future<ArticleProvider> fetchArticlePreviewById(String aid) async {
    DocumentSnapshot data = await _fdb.collection(cArticles).doc(aid).get();
    return _buildArticleByMap(data.id, data.data());
  }

  ArticleProvider findById(String id) {
    return _articles.firstWhere((a) => a.id == id, orElse: () {
      return null;
    });
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
