import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/navbar.dart';

class AppInfoScreen extends StatelessWidget {
  static const routeName = '/app_info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "关于随行派"),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/app_logo.png"),
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: MyColors.lightGreen,
                          width: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("随行派",
                          style: Theme.of(context).textTheme.buttonMedium1),
                    ),
                    FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (ctx, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          if (asyncSnapshot.error != null)
                            return Center(child: Text('An error occurred'));
                          String currentVersion = asyncSnapshot.data.version;
                          String newestVersion = Provider.of<SettingProvider>(
                                  context,
                                  listen: false)
                              .newestVersion;
                          return Column(children: [
                            Text(currentVersion,
                                style: Theme.of(context).textTheme.captionGrey),
                            SizedBox(height: 10),
                            Text(
                                (newestVersion == currentVersion)
                                    ? "当前已是最新版本"
                                    : "还不是最新版本，请升级",
                                style: Theme.of(context).textTheme.captionGrey)
                          ]);
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text("随行工作室 版权所有",
                        style: Theme.of(context).textTheme.captionSmall),
                    Text(
                        "Copyright @ 2019-2020 Follow God Studio. All rights reserved.",
                        style: Theme.of(context).textTheme.captionSmall)
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
