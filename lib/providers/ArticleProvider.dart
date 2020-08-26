import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../model/Constants.dart';

class ArticleProvider with ChangeNotifier {
  final String articleId;
  Map<String, dynamic> _article = {};

  ArticleProvider(this.articleId);

  Map<String, dynamic> get article {
    return _article;
  }

  Future<void> load() async {
    final fStore = Firestore.instance;
    DocumentSnapshot doc = await fStore
        .collection(COLLECTION_ARTICLES)
        .document(this.articleId)
        .get();
    _article = doc.data;
    notifyListeners();
  }
}
