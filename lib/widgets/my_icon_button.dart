import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIconButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color iconColor;
  final double buttonSize;
  final bool hasBorder;
  final bool isActive;
  final Function onPressed;
  final IconData flutterIcon;

  MyIconButton(
      {this.icon,
      this.iconSize = 20,
      this.iconColor = const Color.fromARGB(255, 128, 128, 128),
      this.buttonSize = 40,
      this.onPressed,
      this.hasBorder = false,
      this.isActive = false,
      this.flutterIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: hasBorder ? buttonSize : iconSize,
      height: hasBorder ? buttonSize : iconSize,
      child: FlatButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: () => onPressed(),
          child: (icon != null)
              ? SvgPicture.asset('assets/icons/' + icon + '.svg',
                  width: iconSize,
                  height: iconSize,
                  color: isActive ? Colors.white : iconColor)
              : Icon(flutterIcon,
                  color: isActive ? Colors.white : iconColor, size: iconSize),
          color: !hasBorder
              ? Colors.transparent
              : isActive
                  ? Color.fromARGB(255, 50, 197, 255)
                  : Theme.of(context).buttonColor,
          shape: hasBorder ? CircleBorder() : null),
    );
  }
}
