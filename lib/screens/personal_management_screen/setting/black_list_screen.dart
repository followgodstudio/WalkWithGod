import 'package:flutter/material.dart';

import '../../../configurations/theme.dart';

class BlackListScreen extends StatelessWidget {
  static const routeName = '/black_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('黑名单', style: Theme.of(context).textTheme.headline2),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).textTheme.buttonColor2,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
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