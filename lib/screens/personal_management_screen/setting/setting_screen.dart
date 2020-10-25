import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user/setting_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';
import '../../auth_screen/signup_screen.dart';
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
        appBar: NavBar(title: "系统设置"),
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
                          Text("阅读时不自动锁屏",
                              style:
                                  Theme.of(context).textTheme.captionMedium1),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            toggleSize: 17.0,
                            activeColor: MyColors.lightBlue,
                            value: setting.keepScreenAwake,
                            onToggle: (value) {
                              setting.updateSetting(newKeepScreenAwake: value);
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
                              size: 15.0, color: MyColors.lightBlue)
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
                              size: 15.0, color: MyColors.lightBlue)
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
                              size: 15.0, color: MyColors.lightBlue)
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
                              size: 15.0, color: MyColors.lightBlue)
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
                              size: 15.0, color: MyColors.lightBlue)
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    MyTextButton(
                      width: double.infinity,
                      text: "退出登录",
                      onPressed: () {
                        exceptionHandling(context, () async {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logout();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              SignupScreen.routeName,
                              (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
