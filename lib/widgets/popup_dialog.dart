import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class PopUpDialog extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final Function onPressed;
  PopUpDialog(this.isSuccess, this.message, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: 200,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isSuccess)
            Icon(
              Icons.check_circle,
              color: MyColors.suceess,
            ),
          if (!isSuccess)
            Icon(
              Icons.error,
              color: MyColors.error,
            ),
          SizedBox(height: 4.0),
          Center(
              child: Text(message,
                  style: Theme.of(context).textTheme.captionMedium1)),
        ],
      ),
    );
    return AlertDialog(
      elevation: 0,
      backgroundColor: MyColors.silver,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
