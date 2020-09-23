import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class SplashProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;

  bool _isFetching = false;
  String imageUrl = "";
  String author = "";
  String content = "";

  SplashProvider({this.imageUrl, this.author, this.content});

  Future<void> fetchSplashImage() async {
    await _fdb
        .collection("splash_screens")
        .doc("obUzPLIfTbawxBasGEM2")
        .get()
        .then((value) {
      var data = value.data();
      imageUrl = data["image_url"];
      author = data["author"];
      content = data["content"];
    });
  }
}
