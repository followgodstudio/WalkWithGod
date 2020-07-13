import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk_with_god/screens/HomeScreen.dart';
import '../widgets/otp_input.dart';

class PersonalManagementScreen extends StatefulWidget {
  static const routeName = '/personal_management';
  @override
  _PersonalManagementScreen createState() => _PersonalManagementScreen();
}

class _PersonalManagementScreen extends State<PersonalManagementScreen> {
  String _currentUserPhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('Personal Management'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      //padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              FlatButton(
                                  onPressed: null,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      "https://photo.sohu.com/88/60/Img214056088.jpg",
                                      fit: BoxFit.cover,
                                      height: 60.0,
                                      width: 60.0,
                                    ),
                                  )),
                              Text(
                                "你好，凯瑟琳",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      color: Color.fromARGB(255, 255, 235, 133),
                                      width: 8,
                                      height: 50,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("本月累计阅读时间5小时23分钟",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.left),
                                          SizedBox(height: 8.0),
                                          Text("好友排名第17名",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              textAlign: TextAlign.left),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                        textColor:
                                            Color.fromARGB(255, 7, 59, 76),
                                        onPressed: null,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                              height: 30,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                color: Color.fromARGB(
                                                    255, 240, 240, 240),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "我的个人名片",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              )),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
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
                                        color:
                                            Color.fromARGB(255, 168, 218, 220),
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
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
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: Color.fromARGB(255, 240, 240, 240),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
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
                                        color:
                                            Color.fromARGB(255, 168, 218, 220),
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
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
                                  Text("0条未读"),
                                ],
                              ),
                              height: 60,
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: Color.fromARGB(255, 240, 240, 240),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("最近阅读"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}