import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Container(
              //onPressed: null,
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 168, 218, 220),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                    color: Color.fromARGB(255, 255, 255, 255),
                    iconSize: 25,
                    icon: Icon(Icons.mail),
                    tooltip: '我的好友',
                    onPressed: null),
              ),
            ),
            Text("我的消息"),
            SizedBox(
              width: 10,
            ),
            Text("1条未读"),
          ],
        ),
        height: 60,
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: Color.fromARGB(255, 240, 240, 240),
        ),
      ),
    );
  }
}

class Friendship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                    //onPressed: null,
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 168, 218, 220),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          color: Color.fromARGB(255, 255, 255, 255),
                          iconSize: 25,
                          icon: Icon(Icons.person),
                          tooltip: '我的好友',
                          onPressed: null),
                    ),
                  ),
                  Text("我的好友"),
                  SizedBox(
                    width: 5,
                  ),
                  Text("156个关注"),
                ],
              ),
              height: 60,
              width: 185,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                color: Color.fromARGB(255, 240, 240, 240),
              ),
            ),
          ),
          //SizedBox(width: 12),
          Message(),
        ],
      ),
    );
  }
}
