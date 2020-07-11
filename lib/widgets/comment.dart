import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final int id;
  final String author;
  final String avatarUrl;
  final String content;
  final DateTime createdTime;

  Comment(this.id, this.author, this.avatarUrl, this.content, this.createdTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Row(
            //avatar and title / created time
            children: [
              Column(
                //avatar
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(this.avatarUrl),
                    backgroundColor: Colors.brown.shade800,
                  )
                ],
              ),
              Column(
                //title and time
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        this.author,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(DateFormat('yyyy-MM-dd H:m:s')
                          .format(this.createdTime)),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 60,
              ),
              Flexible(
                child: Text(
                  this.content,
                  softWrap: true,
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              IconButton(icon: Icon(Icons.favorite), onPressed: null),
              Text("14"),
              SizedBox(width: 50),
              IconButton(icon: Icon(Icons.comment), onPressed: null),
              Text("20")
            ],
          )
        ],
      ),
    );
  }
}
