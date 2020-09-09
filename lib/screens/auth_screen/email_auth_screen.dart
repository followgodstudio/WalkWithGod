import 'package:flutter/material.dart';

import 'auth_card.dart';

class EmailAuthScreen extends StatelessWidget {
  static const routeName = '/emailauth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(children: [
                  AuthCard(),
                ]))));
  }
}
