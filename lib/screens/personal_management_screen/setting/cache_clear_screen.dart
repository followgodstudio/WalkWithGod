import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';

class CacheClearScreen extends StatelessWidget {
  static const routeName = '/cache_clear';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "缓存清理"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                        future:
                            Provider.of<SettingProvider>(context, listen: true)
                                .updateCacheSize(),
                        builder: (ctx, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting)
                            return MyProgressIndicator();
                          if (asyncSnapshot.error != null)
                            return Center(child: Text('An error occurred'));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("图片",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium1),
                              Consumer<SettingProvider>(
                                  builder: (context, value, child) => Text(
                                      value.imageCacheSize
                                              .toStringAsPrecision(2) +
                                          "M",
                                      style: Theme.of(context)
                                          .textTheme
                                          .captionGrey)),
                            ],
                          );
                        }),
                    MyTextButton(
                      height: 30,
                      text: "清 理",
                      isSmall: true,
                      textColor: MyColors.lightBlue,
                      onPressed: () async {
                        await Provider.of<SettingProvider>(context,
                                listen: false)
                            .clearCache();
                        showPopUpDialog(context, true, "完成清理");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
