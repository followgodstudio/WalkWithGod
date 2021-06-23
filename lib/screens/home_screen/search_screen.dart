import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../configurations/theme.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search';
  final ScrollController _controller = new ScrollController();
  final TextEditingController _keywordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(controller: _controller, slivers: [
      SliverAppBar(
        pinned: true,
        floating: true,
        toolbarHeight: 80.0,
        leadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: SvgPicture.asset('assets/icons/search.svg',
                        width: 20, height: 20, color: MyColors.black),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _keywordController,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.captionMedium1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "搜索文章、品牌、作者、内容",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .captionMedium1
                                .copyWith(color: MyColors.midGrey)),
                      ),
                    ),
                  ),
                  Text("|",
                      style: Theme.of(context)
                          .textTheme
                          .captionMedium1
                          .copyWith(color: MyColors.midGrey)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("取消",
                          style: Theme.of(context).textTheme.captionMedium1))
                ],
              ),
              width: double.infinity),
        ),
        backgroundColor: Theme.of(context).canvasColor,
      )
    ])));
  }
}
