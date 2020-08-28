import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/Constants.dart';

class ArticleProvider with ChangeNotifier {
  final String articleId;
  Map<String, dynamic> _article = {};

  ArticleProvider(this.articleId, this._article);

  Map<String, dynamic> get article {
    return _article;
  }

  Future<void> save() async {
    DocumentSnapshot doc = await Firestore.instance
        .collection(C_ARTICLES)
        .document(this.articleId)
        .get();
    notifyListeners();
  }
}
