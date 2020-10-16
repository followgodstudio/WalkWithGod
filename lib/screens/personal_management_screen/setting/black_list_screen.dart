import 'package:flutter/material.dart';

import '../../../widgets/navbar.dart';

class BlackListScreen extends StatelessWidget {
  static const routeName = '/black_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "黑名单"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [],
            ),
          ),
        )));
  }
}
