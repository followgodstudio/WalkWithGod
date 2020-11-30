import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:new_version/new_version.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../utils/my_logger.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/navbar.dart';

class AppInfoScreen extends StatelessWidget {
  static const routeName = '/app_info';
  @override
  Widget build(BuildContext context) {
    final newVersion =
        NewVersion(context: context, androidId: "com.suixing.walk_with_god");
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
                          style: Theme.of(context).textTheme.captionMedium1),
                    ),
                    FutureBuilder(
                        future: newVersion.getVersionStatus(),
                        builder: (ctx, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting)
                            return MyProgressIndicator();
                          if (asyncSnapshot.error != null)
                            return Center(child: Text('An error occurred'));
                          String currentVersion =
                              asyncSnapshot.data.localVersion;
                          String newestVersion =
                              asyncSnapshot.data.storeVersion;
                          MyLogger("Widget").i(
                              "AppInfoScreen-build-currentVersion{$currentVersion}-newestVersion{$newestVersion}");
                          return Column(children: [
                            Text(currentVersion,
                                style: Theme.of(context).textTheme.captionGrey),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    (newestVersion == currentVersion)
                                        ? "当前已是最新版本"
                                        : "还不是最新版本，请",
                                    style: Theme.of(context)
                                        .textTheme
                                        .captionGrey),
                                if (newestVersion != currentVersion)
                                  GestureDetector(
                                    onTap: () {
                                      LaunchReview.launch(
                                          androidAppId:
                                              "com.suixing.walk_with_god");
                                    },
                                    child: Text("升级",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: MyColors.deepBlue)),
                                  )
                              ],
                            )
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
