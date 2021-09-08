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
import 'feedback_screen.dart';
import 'notification_screen.dart';
import 'privacy_screen.dart';
import 'edit_profile_screen.dart';

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
                    SubPageButton("编辑个人资料", EditProfileScreen.routeName),
                    SubPageButton("隐私", PrivacyScreen.routeName),
                    SubPageButton("通知", NotificationScreen.routeName),
                    SubPageButton("缓存清理", CacheClearScreen.routeName),
                    Divider(),
                    SubPageButton("关于随行派", AppInfoScreen.routeName),
                    SubPageButton("关于我们", AboutUsScreen.routeName),
                    SubPageButton("用户建议", FeedbackScreen.routeName),
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

class SubPageButton extends StatelessWidget {
  final String buttonText;
  final String routeName;
  SubPageButton(this.buttonText, this.routeName);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 8.0)),
      onPressed: () {
        Navigator.of(context).pushNamed(this.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.buttonText,
              style: Theme.of(context).textTheme.captionMedium1),
          Icon(Icons.arrow_forward_ios, size: 15.0, color: MyColors.lightBlue)
        ],
      ),
    );
  }
}
