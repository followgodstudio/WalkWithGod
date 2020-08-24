import 'package:flutter/material.dart';

import './AuthCard.dart';

class EmailAuthScreen extends StatelessWidget {
  static const routeName = '/emailauth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: AuthCard()));
  }
}
