import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './article.dart';
import '../model/Constants.dart';

class Articles with ChangeNotifier {
  List<Article> _items = [];
  // var _showFavoritesOnly = false;
  // final String authToken;
  // final String userId;

  Articles();

  List<Article> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Article> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Article findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetArticlesByDate([DateTime dateTime = null]) async {
    final fStore = Firestore.instance;

    if (dateTime == null) {
      dateTime = DateTime.now();
    }

    final List<Article> loadedArticles = [];

    await fStore
        .collection(C_ARTICLES)
        // .where("createdDate", isGreaterThanOrEqualTo: dateTime).orderBy("createdDate").limit(10)
        .getDocuments()
        .then((string) => string.documents.forEach((data) {
              loadedArticles.add(Article(
                  id: data.documentID,
                  title: data['title'],
                  description: data['description'],
                  // isFavorite:
                  //     favoriteData == null ? false : favoriteData[prodId] ?? false,
                  imageUrl: data['imageUrl'],
                  author: data['author'],
                  content: data['content'],
                  icon: data['icon']));
            }));
    _items = loadedArticles;

    notifyListeners();
  }
}
