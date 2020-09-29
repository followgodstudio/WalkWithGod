import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../screens/personal_management_screen/headline/network_screen.dart';

class ProfilePicture extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final double radius;
  ProfilePicture(this.radius, [this.imageUrl, this.uid]);

  @override
  Widget build(BuildContext context) {
    CircleAvatar circle = CircleAvatar(
        radius: radius,
        backgroundImage: (imageUrl == null || imageUrl.isEmpty)
            ? AssetImage("assets/images/default_profile_picture.jpg")
            : CachedNetworkImageProvider(imageUrl));
    if (uid == null) return circle;
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
