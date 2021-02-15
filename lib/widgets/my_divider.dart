import 'package:flutter/material.dart';

/// This is a divider without padding, and implements PreferredSizeWidget
class MyDivider extends StatelessWidget implements PreferredSizeWidget {
  final double thickness;
  final Color color;
  final EdgeInsets padding;

  MyDivider({this.thickness = 0.4, this.color, this.padding = EdgeInsets.zero});

  @override
  Size get preferredSize => Size.fromHeight(thickness);

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? Theme.of(context).dividerColor;
    return Padding(
        padding: padding, child: Container(color: _color, height: thickness));
  }
}
