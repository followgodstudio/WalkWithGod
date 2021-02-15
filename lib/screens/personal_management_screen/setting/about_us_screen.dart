import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/navbar.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);
    return Scaffold(
        appBar: NavBar(title: "关于我们"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: FutureBuilder(
                  future: setting.fetchAboutUs(),
                  builder: (ctx, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) return MyProgressIndicator();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text("我们是谁",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                        ),
                        Text(setting.whoAreWe,
                            style: Theme.of(context).textTheme.bodyText1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text("我们的使命",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                        ),
                        Text(setting.ourMission,
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    );
                  })),
        )));
  }
}
