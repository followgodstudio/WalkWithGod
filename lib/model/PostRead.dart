import 'package:flutter/foundation.dart';

class PostRead {
  final String photoURL;
  final String subject;
  final int percentage;
  final String authorName;
  final int postId;
  final DateTime updatedAt;

  PostRead({
    @required this.photoURL,
    @required this.subject,
    @required this.percentage,
    @required this.authorName,
    @required this.postId,
    @required this.updatedAt,
  });
}

final postReadList = [
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
  ),
];
