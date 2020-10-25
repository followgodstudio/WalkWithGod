import 'package:flutter/material.dart';

import '../configurations/theme.dart';

enum TextButtonStyle { active, regular, disabled }

class MyTextButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final bool hasBorder;
  final TextButtonStyle style;
  final bool isSmall;
  final double height;
  final double width;
  final Function onPressed;

  MyTextButton({
    @required this.text,
    this.textColor,
    this.hasBorder = true,
    this.style = TextButtonStyle.regular,
    this.isSmall = false,
    this.height,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color _textColor = textColor ??
        (style == TextButtonStyle.active
            ? Colors.white
            : (style == TextButtonStyle.disabled
                ? MyColors.grey
                : MyColors.black));
    Color _buttonColor = style == TextButtonStyle.active
        ? MyColors.lightBlue
        : Theme.of(context).buttonColor;
    Widget _textChild = Text(text,
        style: isSmall
            ? Theme.of(context)
                .textTheme
                .captionSmall2
                .copyWith(color: _textColor)
            : Theme.of(context)
                .textTheme
                .captionMedium1
                .copyWith(color: _textColor));
    if (!hasBorder)
      return GestureDetector(
          onTap: () {
            if (onPressed != null) onPressed();
          },
          child: _textChild);
    return Container(
      width: width,
      height: height,
      child: FlatButton(
        onPressed: () {
          if (style == TextButtonStyle.disabled) return;
          if (onPressed != null) onPressed();
        },
        child: _textChild,
        color: _buttonColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        padding: const EdgeInsets.all(0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
