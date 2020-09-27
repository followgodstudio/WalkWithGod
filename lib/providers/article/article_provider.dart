import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import 'articles_provider.dart';

class Paragraph {
  final String subtitle;
  final String body;

  Paragraph({
    @required this.subtitle,
    @required this.body,
  });
}

class ArticleProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String icon;
  final String authorName;
  final String authorUid;
  final DateTime createdDate;
  final String publisher;
  List<Paragraph> content = [];
  List<ArticleProvider> _similarArticles = [];
  bool isSaved;

  ArticleProvider(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.icon,
      @required this.authorName,
      @required this.authorUid,
      @required this.createdDate,
      this.imageUrl,
      this.publisher});

  List<ArticleProvider> get similarArticles {
    return [..._similarArticles];
  }

  Future<void> fetchSimilarArticles([limit = loadLimit]) async {
    _similarArticles = [];
    print("ArticleProvider-fetchSimilarArticles");
    // Find articles of this author
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fArticleAuthorName, isEqualTo: this.authorName)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    query.docs.forEach((data) {
      if (data.id != this.id)
        _similarArticles
            .add(ArticlesProvider.buildArticleByMap(data.id, data.data()));
    });
    notifyListeners();
  }

  Future<void> fetchArticleContent() async {
    print("ArticleProvider-fetchArticleContent");
    QuerySnapshot querySnapshot = await _fdb
        .collection(cArticles)
        .doc(id)
        .collection(cArticleContent)
        .orderBy(fContentIndex)
        .get();
    if (querySnapshot == null) return;
    content = [];
    querySnapshot.docs.forEach((element) {
      String subtitle = "";
      if (element.data().containsKey(fContentSubtitle))
        subtitle = element.get(fContentSubtitle);
      content
          .add(Paragraph(subtitle: subtitle, body: element.get(fContentBody)));
    });
    notifyListeners();
  }
}
