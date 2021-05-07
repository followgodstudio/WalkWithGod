import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
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
  MyLogger _logger = MyLogger("Provider");
  String id;
  String imageUrl;
  String title;
  String description;
  String icon;
  String authorName;
  String authorUid;
  DateTime createdDate;
  int readCount;
  String publisher;
  List<Paragraph> content = [];
  String contentHtml;
  List<ArticleProvider> similarArticles = [];
  bool isSaved;
  bool isFetchedSimilarArticles = false;

  ArticleProvider(
      {this.id,
      this.title,
      this.description,
      this.icon,
      this.authorName,
      this.authorUid,
      this.createdDate,
      this.imageUrl,
      this.readCount,
      this.publisher});

  Future<void> fetchSimilarArticles([limit = loadLimit]) async {
    if (isFetchedSimilarArticles) return;
    _logger.i("ArticleProvider-fetchSimilarArticles");
    isFetchedSimilarArticles = true;
    // Find articles of this author
    QuerySnapshot query = await _fdb
        .collection(cArticles)
        .where(fArticleAuthorName, isEqualTo: this.authorName)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    similarArticles = [];
    query.docs.forEach((data) {
      if (data.id != this.id)
        similarArticles
            .add(ArticlesProvider.buildArticleByMap(data.id, data.data()));
    });
    notifyListeners();
  }

  Future<void> fetchArticleContent() async {
    if (content.isNotEmpty) return;
    _logger.i("ArticleProvider-fetchArticleContent");
    QuerySnapshot querySnapshot = await _fdb
        .collection(cArticles)
        .doc(id)
        .collection(cArticleContent)
        .orderBy(fContentIndex)
        .get();
    if (querySnapshot.docs.length > 0) {
      content = [];
      querySnapshot.docs.forEach((element) {
        String subtitle = "";
        if (element.data().containsKey(fContentSubtitle))
          subtitle = element.get(fContentSubtitle);
        content.add(
            Paragraph(subtitle: subtitle, body: element.get(fContentBody)));
      });
    }
    // Get content html
    querySnapshot = await _fdb
        .collection(cArticles)
        .doc(id)
        .collection(cArticleContentHtml)
        .get();
    if (querySnapshot.docs.length > 0) {
      contentHtml = "";
      querySnapshot.docs.forEach((element) {
        contentHtml += element.get(fContentBody);
      });
    }
    notifyListeners();
  }

  Future<void> updateReadCount() async {
    readCount += 1;
    notifyListeners();
    await _fdb
        .collection(cArticles)
        .doc(id)
        .update({fArticleReadCount: FieldValue.increment(1)});
  }

  void deepCopy(ArticleProvider target) {
    if (target == null) return;
    id = target.id;
    title = target.title;
    description = target.description;
    icon = target.icon;
    authorName = target.authorName;
    authorUid = target.authorUid;
    createdDate = target.createdDate;
    imageUrl = target.imageUrl;
    readCount = target.readCount;
    publisher = target.publisher;
    content = target.content;
    similarArticles = target.similarArticles;
    notifyListeners();
  }
}
