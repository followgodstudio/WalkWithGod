import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  final String articleId;
  final Map<String, dynamic> article;

  Article(this.articleId, this.article);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(article['title'] != null ? article['title'] : ""),
        Text(article['author'] != null ? article['author'] : ""),
        Text(article['created_date'] != null
            ? (article['created_date'].toDate() as DateTime).toIso8601String()
            : ""),
        Text(article['content'] != null ? article['content'][0]['body'] : ""),
        Text(article['image_url'] != null ? article['image_url'] : ""),
      ],
    );
  }
}
