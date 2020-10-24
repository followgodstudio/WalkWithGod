import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../widgets/navbar.dart';
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("隐藏你最近的阅读内容",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium1),
                              SizedBox(height: 4),
                              Text("开启后，关注你的好友将看不到你的\"最近阅读\"内容。",
                                  style:
                                      Theme.of(context).textTheme.captionSmall),
                            ],
                          ),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            toggleSize: 17.0,
                            activeColor: Colors.blue[300],
                            value: setting.hideRecentRead,
                            onToggle: (value) {
                              setting.updateSetting(newHideRecentRead: value);
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("关注你须获得你的同意TODO",
                                style:
                                    Theme.of(context).textTheme.captionMedium1),
                            FlutterSwitch(
                              width: 50.0,
                              height: 25.0,
                              toggleSize: 17.0,
                              activeColor: Colors.blue[300],
                              value: setting.allowFollowing,
                              onToggle: (value) {
                                setting.updateSetting(newAllowFollowing: value);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("不接受未关注人的私信TODO",
                                style:
                                    Theme.of(context).textTheme.captionMedium1),
                            FlutterSwitch(
                              width: 50.0,
                              height: 25.0,
                              toggleSize: 17.0,
                              activeColor: Colors.blue[300],
                              value: setting.rejectStrangerMessage,
                              onToggle: (value) {
                                setting.updateSetting(
                                    newRejectStrangerMessage: value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(BlackListScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("黑名单TODO",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.0, color: Colors.blue[300])
                        ],
                      ),
                    ),
                    Divider(),
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(DeleteAccountScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("注销用户",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.0, color: Colors.blue[300])
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
