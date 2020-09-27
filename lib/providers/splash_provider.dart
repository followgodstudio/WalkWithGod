import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../configurations/constants.dart';

class SplashProvider with ChangeNotifier {
  var _fdb = FirebaseFirestore.instance;
  String imageUrl;
  String author;
  String content;

  Future<void> fetchSplashScreensData() async {
    print("SplashScreen-fetchSplashScreensData");
    var splashRefs = _fdb.collection(cSplashScreen);
    var random = _fdb.collection(cSplashScreen).doc().id;
    Map<String, dynamic> data;
    await splashRefs
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: random)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.size > 0) {
        data = snapshot.docs.first.data();
      } else {
        await splashRefs
            .where(FieldPath.documentId, isLessThan: random)
            .limit(1)
            .get()
            .then((value) {
          data = value.docs.first.data();
        });
      }
      imageUrl = data[fSplashScreenImageUrl];
      author = data[fSplashScreenAuthor];
      content = data[fSplashScreenContent];
    });
  }
}
