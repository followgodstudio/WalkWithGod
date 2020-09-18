import 'package:flutter/widgets.dart';

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
  final String authorName;
  final String authorUid;
  final DateTime createdDate;
  List<Paragraph> content;
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
}
