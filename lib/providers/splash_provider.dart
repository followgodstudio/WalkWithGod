import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class SplashProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  bool _isFetching = false;
  //String image_url;

  SplashProvider();

  // List<ArticleProvider> _articles = [];

  // List<ArticleProvider> get articles {
  //   return [..._articles];
  // }

  Future<String> fetch_splash_image() async {
    String imageUrl = "";
    await _fdb
        .collection("app_info")
        .doc("images")
        .get()
        .then((doc) => imageUrl = doc.get("splash_screen")[0]);

    return imageUrl;
    // query.then((value) {
    //   SplashProvider splashProvider = (image_url = value.get("image_url"));
    // });
  }
}
