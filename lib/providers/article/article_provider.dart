import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../model/constants.dart';

class ArticleProvider with ChangeNotifier {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String icon;
  final String author;
  final List content;

  ArticleProvider(
      {@required this.id,
      this.imageUrl,
      @required this.title,
      @required this.description,
      @required this.icon,
      @required this.author,
      @required this.content});

  Future<void> save() async {
    //TODO
    DocumentSnapshot doc =
        await Firestore.instance.collection(cArticles).document(this.id).get();
    notifyListeners();
  }
}
