import 'package:flutter/foundation.dart';

import 'User.dart';

class CommentPreview {
  final int id;
  final int postId;
  final String content;
  final DateTime updatedAt;
  final User user;

  CommentPreview({
    @required this.id,
    @required this.postId,
    @required this.content,
    @required this.updatedAt,
    @required this.user,
  });
}

final commentPreviewList = [
  CommentPreview(
    content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
    id: 1,
    postId: 1,
    updatedAt: DateTime.now(),
    user: dummyUser,
  ),
  CommentPreview(
    content: "这是一段留言，是用户留下的留言，在这里仅仅是为了示范，留言会是一个什么样子。这篇文章写得挺好的。",
    id: 2,
    postId: 2,
    updatedAt: DateTime.now(),
    user: dummyUser,
  ),
];
