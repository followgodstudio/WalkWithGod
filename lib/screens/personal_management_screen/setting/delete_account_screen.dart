import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/utils.dart';
import '../../auth_screen/signup_screen.dart';

class DeleteAccountScreen extends StatelessWidget {
  static const routeName = '/delete_account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('注销用户', style: Theme.of(context).textTheme.headline2),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text("您正在申请注销该账号",
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 20),
                Text("账号注销后，你将永久性失去你账号中的所有内容，包括：",
                    style: Theme.of(context).textTheme.bodyTextBlack),
                SizedBox(height: 20),
                Row(
                  children: [
                    _Circle("1"),
                    SizedBox(width: 10),
                    Text("你所收藏的所有文章",
                        style: Theme.of(context).textTheme.bodyTextBlack),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _Circle("2"),
                    SizedBox(width: 10),
                    Text("你所关注的所有好友",
                        style: Theme.of(context).textTheme.bodyTextBlack),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _Circle("3"),
                    SizedBox(width: 10),
                    Text("你所收到的所有消息",
                        style: Theme.of(context).textTheme.bodyTextBlack),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                    width: double.infinity,
                    child: FlatButton(
                        onPressed: () {
                          exceptionHandling(context, () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .deleteUser();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                SignupScreen.routeName,
                                (Route<dynamic> route) => false);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("我已知悉，并确认注销",
                              style: Theme.of(context).textTheme.bodyTextWhite),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.blue[300])),
              ],
            ),
          ),
        )));
  }
}

class _Circle extends StatelessWidget {
  final String index;
  _Circle(this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Center(
          child: Text(index, style: Theme.of(context).textTheme.headline6)),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color.fromARGB(255, 195, 255, 235)),
    );
  }
}
