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
            ? Theme.of(context).textTheme.button.copyWith(color: _textColor)
            : Theme.of(context)
                .textTheme
                .captionMedium1
                .copyWith(color: _textColor));
    if (!hasBorder)
      return InkWell(
          onTap: () {
            if (onPressed != null) onPressed();
          },
          child: _textChild);
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (style == TextButtonStyle.disabled) return;
          if (onPressed != null) onPressed();
        },
        child: _textChild,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          primary: _buttonColor,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}
