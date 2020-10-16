import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/navbar.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "关于我们"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("我们是谁",
                        style: Theme.of(context).textTheme.captionMedium1),
                  ),
                  Text(
                      Provider.of<SettingProvider>(context, listen: false)
                          .whoAreWe,
                      style: Theme.of(context).textTheme.bodyTextBlack),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("我们的使命",
                        style: Theme.of(context).textTheme.captionMedium1),
                  ),
                  Text(
                      Provider.of<SettingProvider>(context, listen: false)
                          .ourMission,
                      style: Theme.of(context).textTheme.bodyTextBlack),
                ],
              )),
        )));
  }
}
