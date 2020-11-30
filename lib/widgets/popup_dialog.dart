import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class PopUpDialog extends StatelessWidget {
  final bool isSuccess;
  final String message;
  PopUpDialog(this.isSuccess, this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        backgroundColor: MyColors.silver,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(10.0),
        content: Container(
          width: 200,
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
        ));
  }
}
