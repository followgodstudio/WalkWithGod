import 'package:flutter/material.dart';

/// This is a divider without padding, and implements PreferredSizeWidget
class MyDivider extends StatelessWidget implements PreferredSizeWidget {
  final double indent;
  final double thickness;
  final Color color;

  MyDivider({this.indent = 0.0, this.thickness = 0.4, this.color});

  @override
  Size get preferredSize => Size.fromHeight(thickness);

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? Theme.of(context).dividerColor;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: indent),
        child: Container(color: _color, height: thickness));
  }
}
