import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../model/Constants.dart';

class Article with ChangeNotifier {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String icon;
  final String author;
  final List content;
  bool isFavorite;

  Article({
    @required this.id,
    this.imageUrl,
    @required this.title,
    @required this.description,
    @required this.icon,
    @required this.author,
    @required this.content,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  //   Future<void> toggleFavoriteStatus(String token, String userId) async {
  //   final oldStatus = isFavorite;
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  //   final url =
  //       'https://flutter-update.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
  //   try {
  //     final response = await http.put(
  //       url,
  //       body: json.encode(
  //         isFavorite,
  //       ),
  //     );
  //     if (response.statusCode >= 400) {
  //       _setFavValue(oldStatus);
  //     }
  //   } catch (error) {
  //     _setFavValue(oldStatus);
  //   }
  // }

  //Map<String, dynamic> _article = {};

  // Map<String, dynamic> get article {
  //   return _article;
  // }

  // Future<void> load() async {
  //   final fStore = Firestore.instance;
  //   DocumentSnapshot doc =
  //       await fStore.collection(C_ARTICLES).document(this.articleId).get();
  //   _article = doc.data;
  //   notifyListeners();
  // }
}
