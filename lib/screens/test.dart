import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        title: 'Easy Web View',
      ),
      body: EasyWebView(
        src: 'https://proandroiddev.com/flutter-render-html-2a51f73f9db',
        isHtml: false,
        isMarkdown: false,
        convertToWidgets: false,
      ),
    );
  }
}
