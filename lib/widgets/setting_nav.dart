import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class SettingNav extends StatelessWidget {
  final String title;
  final String routeName;

  SettingNav({this.title, this.routeName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 8.0)),
      onPressed: () {
        Navigator.of(context).pushNamed(this.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.title, style: Theme.of(context).textTheme.captionMedium1),
          Icon(Icons.arrow_forward_ios, size: 15.0, color: MyColors.lightBlue)
        ],
      ),
    );
  }
}
