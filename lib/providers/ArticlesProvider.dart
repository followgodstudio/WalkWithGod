// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import './ArticleProvider.dart';

// class ArticlesProvider with ChangeNotifier {
//   List<Article> _articles =[];

//   final String articleId;
//   Map<String, dynamic> _article = {};

//   ArticleProvider(this.articleId);

//   Map<String, dynamic> get article {
//     return _article;
//   }

//   Future<void> load() async {
//     final fStore = Firestore.instance;
//     DocumentSnapshot doc =
//         await fStore.collection(C_ARTICLES).document(this.articleId).get();
//     _article = doc.data;
//     notifyListeners();
//   }
// }
