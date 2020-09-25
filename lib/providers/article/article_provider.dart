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
  List<Paragraph> content;
  List<ArticleProvider> _similarArticles = [];
  final String publisher;

  ArticleProvider(
      {@required this.id,
      this.imageUrl,
      @required this.title,
      @required this.description,
      @required this.icon,
      @required this.authorName,
      @required this.authorUid,
      @required this.createdDate,
      this.content,
      this.publisher});

  List<ArticleProvider> get similarArticles {
    return [..._similarArticles];
  }

  Future<void> findSimilarArticles([limit = loadLimit]) async {
    _similarArticles = [];
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
            .add(ArticlesProvider().buildArticleByMap(data.id, data.data()));
    });
  }
}
