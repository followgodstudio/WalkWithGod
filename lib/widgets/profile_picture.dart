import 'package:flutter/material.dart';

import '../screens/personal_management_screen/network/network_screen.dart';

class ProfilePicture extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final double radius;
  ProfilePicture(this.imageUrl, this.radius, [this.uid]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (uid == null || uid.isEmpty) return;
          Navigator.of(context).pushNamed(
            NetworkScreen.routeName,
            arguments: uid,
          );
        },
        child: CircleAvatar(
            radius: radius,
            backgroundImage: (imageUrl == null || imageUrl.isEmpty)
                ? AssetImage("assets/images/default_profile_picture.jpg")
                : NetworkImage(imageUrl)));
  }
}
