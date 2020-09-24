import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class SplashProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;

  bool _isFetching = false;
  String imageUrl = "";
  String author = "";
  String content = "";

  SplashProvider({this.imageUrl, this.author, this.content});

  Future<void> fetchSplashScreensData() async {
    var splashRefs = _fdb.collection("splash_screens");
    var random = _fdb.collection("splash_screens").doc().id;
    Map<String, dynamic> data;
    await splashRefs
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: random)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.size > 0) {
        data = snapshot.docs.first.data();
        print("data1");
      } else {
        await splashRefs
            .where(FieldPath.documentId, isLessThan: random)
            .limit(1)
            .get()
            .then((value) {
          data = value.docs.first.data();
          print("data2");
        });
      }
      imageUrl = data["image_url"];
      author = data["author"];
      content = data["content"];
    });
  }
}
