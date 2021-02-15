import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../configurations/theme.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String description;
  final bool switchValue;
  final Function switchFunction;

  SettingItem(
      {this.title,
      this.description = "",
      this.switchValue,
      this.switchFunction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(this.title, style: Theme.of(context).textTheme.captionMedium1),
            if (this.description != "") SizedBox(height: 4),
            if (this.description != "")
              Text(this.description,
                  style: Theme.of(context).textTheme.captionSmall),
          ],
        )),
        FlutterSwitch(
          width: 50.0,
          height: 25.0,
          toggleSize: 17.0,
          activeColor: MyColors.lightBlue,
          value: this.switchValue,
          onToggle: (value) {
            this.switchFunction(value);
          },
        ),
      ],
    );
  }
}
