import 'package:flutter/material.dart';

import 'package:app_login_ui/personal-management/model/User.dart';

import 'HeadLine.dart';



void main() {
  final user = new User(name:"凯瑟琳", photo: "");

  runApp(MaterialApp(
    title: 'Shopping Application',
    home: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            HeadLine(userName:user.name, photoPath:user.photo),
            //Summary(),

          ],
        )
    )
  ));
}
