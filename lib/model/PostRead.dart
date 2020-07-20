import 'package:flutter/cupertino.dart';

class PostRead {
  final String photoURL;
  final String subject;
  final int percentage;
  final String authorName;
  final int postId;
  final DateTime updatedAt;

  PostRead(
      {@required this.photoURL,
      @required this.subject,
      @required this.percentage,
      @required this.authorName,
      @required this.postId,
      @required this.updatedAt});
}

final postReadList = [
  PostRead(
      photoURL:
          'https://static01.nyt.com/images/2020/05/20/business/20Techfix-illo/20Techfix-illo-articleLarge.gif?quality=90&auto=webp',
      subject: "只要",
      percentage: 85,
      authorName: "范学德",
      postId: 1,
      updatedAt: DateTime.now()),
  PostRead(
      photoURL:
          'https://static01.nyt.com/images/2020/05/20/business/20Techfix-illo/20Techfix-illo-articleLarge.gif?quality=90&auto=webp',
      subject: "只要互联网还在",
      percentage: 85,
      authorName: "范学德",
      postId: 2,
      updatedAt: DateTime.now()),
  PostRead(
      photoURL:
          'https://static01.nyt.com/images/2020/05/20/business/20Techfix-illo/20Techfix-illo-articleLarge.gif?quality=90&auto=webp',
      subject: "只要互联网还在，我就",
      percentage: 85,
      authorName: "范学德",
      postId: 3,
      updatedAt: DateTime.now()),
  PostRead(
      photoURL:
          'https://static01.nyt.com/images/2020/05/20/business/20Techfix-illo/20Techfix-illo-articleLarge.gif?quality=90&auto=webp',
      subject: "只要互联网还在，我就不会停止敲",
      percentage: 85,
      authorName: "范学德",
      postId: 4,
      updatedAt: DateTime.now())
];
