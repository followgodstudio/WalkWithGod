import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';

class AppInfoScreen extends StatelessWidget {
  static const routeName = '/app_info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('关于随行派', style: Theme.of(context).textTheme.headline2),
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
            child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          color: Color.fromARGB(255, 195, 255, 235),
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
                        future: Future.wait([
                          PackageInfo.fromPlatform(),
                        ]),
                        builder: (ctx, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          if (asyncSnapshot.error != null)
                            return Center(child: Text('An error occurred'));
                          String currentVersion = asyncSnapshot.data[0].version;
                          String newestVersion = Provider.of<SettingProvider>(
                                  context,
                                  listen: false)
                              .newestVersion;
                          return Column(children: [
                            Text(currentVersion,
                                style: Theme.of(context).textTheme.captionMain),
                            SizedBox(height: 10),
                            Text(
                                (newestVersion == currentVersion)
                                    ? "当前已是最新版本"
                                    : "还不是最新版本，请升级",
                                style: Theme.of(context).textTheme.captionMain)
                          ]);
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text("随行工作室 版权所有",
                        style: Theme.of(context).textTheme.captionSmall1),
                    Text(
                        "Copyright @ 2019-2020 Follow God Studio. All rights reserved.",
                        style: Theme.of(context).textTheme.captionSmall1)
                  ],
                )
              ],
            ),
          ),
        )));
  }
}