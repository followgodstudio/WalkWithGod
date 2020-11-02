import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class MyBottomIndicator extends StatelessWidget {
  final bool isNoMore;
  MyBottomIndicator(this.isNoMore);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(isNoMore ? "到底啦" : "加载更多...",
            style: Theme.of(context).textTheme.captionMedium2),
      ),
    );
  }
}
