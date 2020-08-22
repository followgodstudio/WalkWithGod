import 'package:flutter/material.dart';

import '../model/PostRead.dart';

class Articles with ChangeNotifier {
  List<PostRead> _items = [];

  List<PostRead> get items {
    return [...items];
  }

  void addPost() {
    notifyListeners();
  }
}
