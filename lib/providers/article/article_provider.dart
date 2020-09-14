import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class Paragraph {
  final String subtitle;
  final String body;

  Paragraph({
    @required this.subtitle,
    @required this.body,
  });
}

class ArticleProvider with ChangeNotifier {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String icon;
  final String author;
  final DateTime createdDate;
  List<Paragraph> content;
  final String publisher;

  ArticleProvider(
      {@required this.id,
      this.imageUrl,
      @required this.title,
      @required this.description,
      @required this.icon,
      @required this.author,
      @required this.createdDate,
      this.content,
      this.publisher});

  Future<void> save() async {
    //TODO
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(cArticles)
        .doc(this.id)
        .get();
    notifyListeners();
  }
}
