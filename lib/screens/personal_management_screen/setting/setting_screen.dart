import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user/setting_provider.dart';
import 'about_us_screen.dart';
import 'app_info_screen.dart';
import 'cache_clear_screen.dart';
import 'notification_screen.dart';
import 'privacy_screen.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('设置', style: Theme.of(context).textTheme.headline2),
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
                          Text("阅读时不自动锁屏",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            toggleSize: 17.0,
                            activeColor: Colors.blue[300],
                            value: setting.keepScreenAwakeOnRead,
                            onToggle: (value) {
                              setting.updateSetting(
                                  newKeepScreenAwakeOnRead: value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(),
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(PrivacyScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("隐私",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.0, color: Colors.blue[300])
                        ],
                      ),
                    ),
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(NotificationScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("通知",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.0, color: Colors.blue[300])
                        ],
                      ),
                    ),
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CacheClearScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("缓存清理",
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
                            .pushNamed(AppInfoScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("关于随行派",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.0, color: Colors.blue[300])
                        ],
                      ),
                    ),
                    FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AboutUsScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("关于我们",
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
