import 'package:flutter/foundation.dart';
import 'package:walk_with_god/model/Platform.dart';

class PostSaved {
  final String photoURL;
  final String subject;
  final Platform platform;
  final String authorName;

  PostSaved({
    @required this.photoURL,
    @required this.subject,
    @required this.authorName,
    @required this.platform,
  });
}

final PostSavedLists = [
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
<<<<<<< HEAD
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
  PostSaved(
    photoURL: 'assets/images/image0.jpg',
    authorName: "范学德",
    subject: "只要互联网还在，我就不会停止敲打键盘",
    platform: Platform(
      id: 1,
      name: "海外校园",
      logoURL: "assets/images/icon.jpeg",
    ),
  ),
=======
>>>>>>> WIP saved posts
];
