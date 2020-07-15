import 'package:flutter/widgets.dart';

class User {
  final int id;
  final String user_name;
  final String name;
  final String avatar_url;

  User({
    @required this.id,
    @required this.user_name,
    this.name,
    this.avatar_url,
  });
}