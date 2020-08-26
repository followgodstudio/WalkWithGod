import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/Constants.dart';
import '../../providers/UserProvider/MessageProvider.dart';

class TestMessages extends StatelessWidget {
  TestMessages(String uid);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Messages:"),
        RaisedButton(
            child: Text("Add message"),
            onPressed: () {
              Provider.of<MessageProvider>(context, listen: false).add(
                  E_USER_MESSAGE_TYPE_COMMENT,
                  'test_uid',
                  'test_aid',
                  "Hello from dart!");
            }),
        Consumer<MessageProvider>(
          builder: (context, data, child) => StreamBuilder(
              stream: data.getStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  docs.sort((d1, d2) {
                    return d1[F_CREATE_DATE].compareTo(d2[F_CREATE_DATE]);
                  });
                  return Column(
                      children: docs
                          .map((doc) => Row(
                                children: [
                                  Text(DateFormat("yyyy-MM-dd hh:mm:ss").format(
                                      (doc.data[F_CREATE_DATE] as Timestamp)
                                          .toDate())),
                                  Text("   "),
                                  Text(doc.data[F_USER_MESSAGE_BODY] != null
                                      ? doc.data[F_USER_MESSAGE_BODY]
                                      : ""),
                                ],
                              ))
                          .toList());
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ],
    );
  }
}
