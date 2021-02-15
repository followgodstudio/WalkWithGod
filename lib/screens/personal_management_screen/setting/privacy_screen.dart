import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/my_divider.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/setting_item.dart';
import '../../../widgets/setting_nav.dart';
import 'black_list_screen.dart';
import 'delete_account_screen.dart';

class PrivacyScreen extends StatelessWidget {
  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "隐私"),
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
                          title: "隐藏你最近的阅读内容",
                          description: "开启后，关注你的好友将看不到你的\"最近阅读\"内容。",
                          switchValue: setting.hideRecentRead,
                          switchFunction: (value) => {
                                setting.updateSetting(newHideRecentRead: value)
                              }),
                      SizedBox(height: 16.0),
                      MyDivider(),
                      SizedBox(height: 16.0),
                      SettingItem(
                          title: "关注你须获得你的同意TODO",
                          description: "开启后，只有你同意的用户才可以关注你，以及查看你的\"最近阅读\"内容。",
                          switchValue: setting.allowFollowing,
                          switchFunction: (value) => {
                                setting.updateSetting(newAllowFollowing: value)
                              }),
                      SizedBox(height: 16.0),
                      SettingItem(
                          title: "不接受未关注人的私信TODO",
                          switchValue: setting.rejectStrangerMessage,
                          switchFunction: (value) => {
                                setting.updateSetting(
                                    newRejectStrangerMessage: value)
                              }),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SettingNav(
                        title: "黑名单TODO", routeName: BlackListScreen.routeName),
                    Divider(),
                    SettingNav(
                        title: "注销用户",
                        routeName: DeleteAccountScreen.routeName),
                    Divider(),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
