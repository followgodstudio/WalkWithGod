import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/setting_item.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "注销用户"),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              children: [
                Consumer<SettingProvider>(
                  builder: (context, setting, child) => Column(
                    children: [
                      SettingItem(
                          title: "接受新关注提醒",
                          description: "关闭后，其他用户关注你时，将不再通知你。",
                          switchValue: setting.followingNotification,
                          switchFunction: (value) => {
                                setting.updateSetting(
                                    newFollowingNotification: value)
                              }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
