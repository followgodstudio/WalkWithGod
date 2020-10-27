import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configurations/theme.dart';

class MyIconButton extends StatelessWidget {
  final String icon;
  final String label;
  final double iconSize;
  final Color iconColor;
  final double buttonSize;
  final double padding;
  final bool hasBorder;
  final bool isActive;
  final Function onPressed;
  final IconData flutterIcon;

  MyIconButton(
      {this.icon,
      this.label,
      this.iconSize = 20,
      this.iconColor = MyColors.grey,
      this.buttonSize = 40,
      this.padding = 0,
      this.onPressed,
      this.hasBorder = false,
      this.isActive = false,
      this.flutterIcon});

  @override
  Widget build(BuildContext context) {
    Widget _icon = (icon != null)
        ? SvgPicture.asset('assets/icons/' + icon + '.svg',
            width: iconSize,
            height: iconSize,
            color: isActive ? Colors.white : iconColor)
        : Icon(flutterIcon,
            color: isActive ? Colors.white : iconColor, size: iconSize);
    if (label != null)
      return InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _icon,
                SizedBox(width: 8.0),
                Text(label, style: Theme.of(context).textTheme.captionMedium2)
              ],
            ),
          ));
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        width: hasBorder ? buttonSize : iconSize,
        height: hasBorder ? buttonSize : iconSize,
        child: FlatButton(
            padding: EdgeInsets.all(0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: onPressed,
            child: _icon,
            color: !hasBorder
                ? Colors.transparent
                : isActive ? MyColors.lightBlue : Theme.of(context).buttonColor,
            shape: hasBorder ? CircleBorder() : null),
      ),
    );
  }
}
