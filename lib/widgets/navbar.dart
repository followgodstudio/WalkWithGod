import 'package:flutter/material.dart';

import '../configurations/theme.dart';
import 'my_divider.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final double _prefferedHeight = 50.0;
  final String title;
  final Widget titleWidget;
  final Color backgroundColor;
  final Color buttonColor;
  final bool isSliverAppBar;
  final bool isFix;
  final bool hasBackButton;
  final Widget actionButton;

  NavBar({
    this.title = "",
    this.titleWidget,
    this.backgroundColor,
    this.buttonColor,
    this.isSliverAppBar = false,
    this.isFix = true,
    this.hasBackButton = true,
    this.actionButton,
  });

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor = backgroundColor ?? Theme.of(context).canvasColor;
    Color _buttonColor =
        buttonColor ?? Theme.of(context).textTheme.buttonColor2;
    Widget _titleWidget = titleWidget ??
        Text(title, style: Theme.of(context).textTheme.captionMedium2);
    Widget action = actionButton;
    if (action == null)
      action = Placeholder(
        color: _backgroundColor,
        fallbackWidth: 60,
      );
    Widget leadingBackButton;
    if (hasBackButton)
      leadingBackButton = IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: _buttonColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    if (!hasBackButton && titleWidget == null) leadingBackButton = SizedBox();
    if (isSliverAppBar)
      return SliverAppBar(
        pinned: isFix,
        floating: !isFix,
        elevation: 0,
        title: _titleWidget,
        leading: leadingBackButton,
        backgroundColor: _backgroundColor,
        actions: [action],
      );
    return AppBar(
      centerTitle: true,
      elevation: 0,
      bottom: MyDivider(indent: 20),
      title: _titleWidget,
      leading: leadingBackButton,
      backgroundColor: _backgroundColor,
      actions: [action],
    );
  }
}
