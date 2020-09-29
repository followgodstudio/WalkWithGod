import 'package:flutter/material.dart';

import '../../../widgets/profile_picture.dart';
import '../../../configurations/theme.dart';

class Introduction extends StatelessWidget {
  final String name;
  final String imageUrl;
  Introduction(this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfilePicture(30.0, imageUrl),
        SizedBox(height: 20.0),
        Text(
          (name == null || name.isEmpty) ? "弟兄姊妹" : name,
          style: Theme.of(context).textTheme.captionMedium1,
        ),
      ],
    );
  }
}
