import 'package:flutter/foundation.dart';

import 'Platform.dart';

class PostRead {
  final String photoURL;
  final String subject;
  final int percentage;
  final String authorName;
  final int postId;
  final DateTime updatedAt;
  final Platform platform;

  PostRead({
    @required this.photoURL,
    @required this.subject,
    @required this.percentage,
    @required this.authorName,
    @required this.postId,
    @required this.updatedAt,
    @required this.platform,
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
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostRead(
    photoURL: 'assets/images/image0.jpg',
    subject: "只要互联网还在，我就不会停…",
    percentage: 85,
    authorName: "范学德",
    postId: 1,
    updatedAt: DateTime.now(),
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
];
