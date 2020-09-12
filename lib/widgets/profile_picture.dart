import 'package:flutter/material.dart';

import '../screens/personal_management_screen/headline/network_screen.dart';

class ProfilePicture extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final double radius;
  ProfilePicture(this.imageUrl, this.radius, [this.uid]);

  @override
  Widget build(BuildContext context) {
    CircleAvatar circle = CircleAvatar(
        radius: radius,
        backgroundImage: (imageUrl == null || imageUrl.isEmpty)
            ? AssetImage("assets/images/default_profile_picture.jpg")
            : NetworkImage(imageUrl));
    if (uid == null || uid.isEmpty) return circle;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            NetworkScreen.routeName,
            arguments: uid,
          );
        },
        child: circle);
  }
}
