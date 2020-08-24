import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../model/Constants.dart';

class ArticleProvider with ChangeNotifier {
  String articleId;
  Map<String, dynamic> article = {};

  ArticleProvider(this.articleId);

  Future<void> load() async {
    final fStore = Firestore.instance;
    try {
      DocumentSnapshot doc = await fStore
          .collection(COLLECTION_ARTICLES)
          .document(this.articleId)
          .get();
      article = doc.data;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
