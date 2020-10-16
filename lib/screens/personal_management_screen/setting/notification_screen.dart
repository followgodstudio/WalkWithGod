import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/navbar.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "注销用户"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Consumer<SettingProvider>(
                  builder: (context, setting, child) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("接受新关注提醒TODO",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            toggleSize: 17.0,
                            activeColor: Colors.blue[300],
                            value: setting.followingNotification,
                            onToggle: (value) {
                              setting.updateSetting(
                                  newFollowingNotification: value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
