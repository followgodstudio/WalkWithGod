import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 8 : 6,
      width: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[500],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}