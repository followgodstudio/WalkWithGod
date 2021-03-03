import 'package:flutter/material.dart';

import 'my_divider.dart';
import 'my_icon_button.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final double expandedHeight;
  final String title;
  final Widget titleWidget;
  final Color backgroundColor;
  final bool isSliverAppBar;
  final bool pinned;
  final bool floating;
  final bool hasBackButton;
  final Widget actionButton;
  final Widget flexibleSpace;

  NavBar({
    this.title = "",
    this.titleWidget,
    this.backgroundColor,
    this.isSliverAppBar = false,
    this.pinned = true,
    this.floating = true,
    this.hasBackButton = true,
    this.actionButton,
    this.expandedHeight = 50.0,
    this.flexibleSpace,
  });

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor = backgroundColor ?? Theme.of(context).canvasColor;
    Widget _titleWidget = titleWidget ??
        Text(title, style: Theme.of(context).textTheme.headline2);
    Widget action = actionButton;
    if (action == null) action = SizedBox(width: 60);
    Widget leadingBackButton;
    if (hasBackButton)
      leadingBackButton = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 30),
              MyIconButton(
                icon: 'back',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    if (!hasBackButton && titleWidget == null) leadingBackButton = SizedBox();
    if (isSliverAppBar)
      return SliverAppBar(
        pinned: pinned,
        floating: floating,
        expandedHeight: expandedHeight,
        elevation: 0,
        title: _titleWidget,
        leading: leadingBackButton,
        backgroundColor: _backgroundColor,
        actions: [action],
        flexibleSpace: flexibleSpace ?? SizedBox(),
      );
    return AppBar(
      centerTitle: true,
      elevation: 0,
      bottom: MyDivider(padding: EdgeInsets.symmetric(horizontal: 20.0)),
      title: _titleWidget,
      leading: leadingBackButton,
      backgroundColor: _backgroundColor,
      actions: [action, SizedBox(width: 30.0)],
      brightness: Brightness.light,
    );
  }
}
