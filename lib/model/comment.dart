import 'package:flutter/material.dart';

class Comment {
  final int id;
  final String content;
  final int number_of_likes;
  final List<int> list_of_comment;
  final User author;
  final DateTime createdDate;

  Comment(
      {@required this.id,
      @required this.content,
      @required this.number_of_likes,
      @required this.list_of_comment,
      @required this.author,
      @required this.createdDate});
}

class User {
  final int id;
  final String user_name;
  final String avatar_url;

  User({
    @required this.id,
    @required this.user_name,
    this.avatar_url,
  });
}

final commentList = [
  Comment(
      id: 1,
      content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
      number_of_likes: 20,
      list_of_comment: [1, 2, 3, 4, 5, 6],
      author: User(
          id: 123456789,
          user_name: "凯瑟琳.泽塔琼斯",
          avatar_url: "https://photo.sohu.com/88/60/Img214056088.jpg"),
      createdDate: DateTime.now()),
  Comment(
      id: 2,
      content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
      number_of_likes: 21,
      list_of_comment: [1, 2, 3, 4, 5, 6],
      author: User(
          id: 123456789,
          user_name: "凯瑟琳.泽塔琼斯",
          avatar_url:
              "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282__340.png"),
      createdDate: DateTime.now()),
  Comment(
      id: 3,
      content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
      number_of_likes: 22,
      list_of_comment: [1, 2, 3, 4, 5, 6],
      author: User(
          id: 123456789,
          user_name: "凯瑟琳.泽塔琼斯",
          avatar_url:
              "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282__340.png"),
      createdDate: DateTime.now()),
  Comment(
      id: 4,
      content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
      number_of_likes: 22,
      list_of_comment: [1, 2, 3, 4, 5, 6],
      author: User(
          id: 123456789,
          user_name: "凯瑟琳.泽塔琼斯",
          avatar_url:
              "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282__340.png"),
      createdDate: DateTime.now()),
  Comment(
      id: 5,
      content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
      number_of_likes: 22,
      list_of_comment: [1, 2, 3, 4, 5, 6],
      author: User(
          id: 123456789,
          user_name: "凯瑟琳.泽塔琼斯",
          avatar_url:
              "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282__340.png"),
      createdDate: DateTime.now()),
];
