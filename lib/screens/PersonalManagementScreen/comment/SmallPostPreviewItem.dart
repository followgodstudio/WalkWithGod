import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostSaved.dart';

class SmallPostPreviewItem extends StatelessWidget {
  SmallPostPreviewItem({this.post});

  final PostSaved post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 35,
            width: 35,
            child: Image.asset(
              post.photoURL,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                post.subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      height: 7,
                      width: 15,
                      child: Image.asset(
                        post.platform.logoURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    '${post.platform.name}',
                    style: Theme.of(context).textTheme.overline,
                  ),
                  Text(
<<<<<<< HEAD
                    '   文 / ${post.authorName}',
=======
                    '文 / ${post.authorName}',
>>>>>>> add comments section
                    style: Theme.of(context).textTheme.overline,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
