import 'package:flutter/material.dart';
import './Typesetting.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: IconButton(
            icon: Icon(Icons.text_format),
            onPressed: () {
              _typeSettingBottomSheet(context);
            },
          ),
        ),
      ),
    );
  }
}

void _typeSettingBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Typesetting();
      });
}
