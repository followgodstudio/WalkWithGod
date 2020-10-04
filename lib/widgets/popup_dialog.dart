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
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        content: Container(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isSuccess)
                Icon(
                  Icons.check_circle,
                  color: Colors.green[300],
                ),
              if (!isSuccess)
                Icon(
                  Icons.error,
                  color: Colors.red,
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
