import 'package:flutter/material.dart';

import 'auth_card.dart';

class EmailAuthScreen extends StatelessWidget {
  static const routeName = '/emailauth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: AuthCard()));
  }
}
