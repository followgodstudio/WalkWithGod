import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class CommentSucceededDialog extends StatelessWidget {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[300],
              ),
              SizedBox(height: 4.0),
              Center(
                  child: Text('你刚刚发布了留言',
                      style: Theme.of(context).textTheme.captionMedium1)),
            ],
          ),
        ));
  }
}
