import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/UserProvider/MessageProvider.dart';

class TestMessages extends StatelessWidget {
  TestMessages(String uid);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<MessageProvider>(context, listen: false).load(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<MessageProvider>(
              builder: (context, data, child) => StreamBuilder(
                  stream: data.getStream(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> docs = snapshot.data.documents;
                      return Column(
                          children: docs
                              .map((doc) => Text(doc.data['content']))
                              .toList());
                    } else {
                      return Text("Loading");
                    }
                  }),
            );
          }
        });
  }
}
