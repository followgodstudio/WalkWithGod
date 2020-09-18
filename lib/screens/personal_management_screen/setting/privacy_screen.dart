import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/providers/user/setting_provider.dart';
import 'package:walk_with_god/screens/personal_management_screen/setting/black_list_screen.dart';
import 'package:walk_with_god/screens/personal_management_screen/setting/delete_account_screen.dart';

import '../../../configurations/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user/profile_provider.dart';

class PrivacyScreen extends StatelessWidget {
  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('隐私', style: Theme.of(context).textTheme.headline2),
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
                Consumer<SettingProvider>(
                  builder: (context, setting, child) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("隐藏你最近的阅读内容",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
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
                            Text("关注你须获得你的同意",
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
                            Text("不接受未关注人的私信",
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
                          Text("黑名单",
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
                    Container(
                        width: double.infinity,
                        child: FlatButton(
                            onPressed: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .logout();
                              Navigator.of(context).pushReplacementNamed('/');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("退出登录",
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Theme.of(context).buttonColor)),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
