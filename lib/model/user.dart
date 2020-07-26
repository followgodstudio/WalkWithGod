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

final dummyUser = User(
  id: 123456789,
  user_name: "凯瑟琳.泽塔琼斯",
  avatar_url: "https://photo.sohu.com/88/60/Img214056088.jpg",
);
