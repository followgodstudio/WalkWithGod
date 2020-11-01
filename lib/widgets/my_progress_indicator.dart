import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }
}
