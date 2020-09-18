import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/succeeded_dialog.dart';

class CacheClearScreen extends StatelessWidget {
  static const routeName = '/cache_clear';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('缓存清理', style: Theme.of(context).textTheme.headline2),
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
                            return Center(child: CircularProgressIndicator());
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
                                          .captionMain)),
                            ],
                          );
                        }),
                    Container(
                      height: 30,
                      child: FlatButton(
                          onPressed: () async {
                            await Provider.of<SettingProvider>(context,
                                    listen: false)
                                .clearCache();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return SucceededDialog("完成清理");
                                });
                          },
                          child: Text("清 理",
                              style:
                                  Theme.of(context).textTheme.captionSmallBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Theme.of(context).buttonColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
