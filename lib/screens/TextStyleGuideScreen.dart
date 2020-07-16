import 'package:flutter/material.dart';
import '../configurations/Theme.dart';

class TextStyleGuideScreen extends StatelessWidget {
  static const routeName = '/textStyleGuide';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Text(
                      "使用守则：在为Text添加样式的时候，直接使用设计好的TextTheme，具体使用方法如下：",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Text(\"这是一个使用范例\", style: Theme.of(context).textTheme.bodyText3)",
                      style: Theme.of(context).textTheme.bodyText3,
                    ),
                  ]),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "This is headLine1",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "这是标题1",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "This is headLine2",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(
                  "这是标题2",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(
                  "This is headLine3",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "这是标题3",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "This is headLine4",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  "这是标题4",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  "This is headLine5",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "这是标题5",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "This is headLine6",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "这是标题6",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "This is subtitle1",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "这是副标题1",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "This is subtitle2",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  "这是副标题2",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  "This is bodyText1",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "这是主题1",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "This is bodyText2",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "这是主题2",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "This is bodyText3",
                  style: Theme.of(context).textTheme.bodyText3,
                ),
                Text(
                  "这是主题3",
                  style: Theme.of(context).textTheme.bodyText3,
                ),
                Text(
                  "This is caption",
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  "这是标示",
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  "This is captionLarge1",
                  style: Theme.of(context).textTheme.captionLarge1,
                ),
                Text(
                  "这是标示(大)1",
                  style: Theme.of(context).textTheme.captionLarge1,
                ),
                Text(
                  "This is captionMedium1",
                  style: Theme.of(context).textTheme.captionMedium1,
                ),
                Text(
                  "这是标示(中)1",
                  style: Theme.of(context).textTheme.captionMedium1,
                ),
                Text(
                  "This is captionSmall1",
                  style: Theme.of(context).textTheme.captionSmall1,
                ),
                Text(
                  "这是标示(小)1",
                  style: Theme.of(context).textTheme.captionSmall1,
                ),
                Text(
                  "This is overline",
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  "这是上划线",
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  "This is button",
                  style: Theme.of(context).textTheme.button,
                ),
                Text(
                  "这是按钮",
                  style: Theme.of(context).textTheme.button,
                ),
                Text(
                  "This is buttonMedium1",
                  style: Theme.of(context).textTheme.buttonLarge1,
                ),
                Text(
                  "这是按钮（大）1",
                  style: Theme.of(context).textTheme.buttonLarge1,
                ),
                Text(
                  "This is buttonMedium1",
                  style: Theme.of(context).textTheme.buttonMedium1,
                ),
                Text(
                  "这是按钮（中）1",
                  style: Theme.of(context).textTheme.buttonMedium1,
                ),
                Text(
                  "This is buttonSmall1",
                  style: Theme.of(context).textTheme.buttonSmall1,
                ),
                Text(
                  "这是按钮（小）1",
                  style: Theme.of(context).textTheme.buttonSmall1,
                ),
                Text(
                  "This is error",
                  style: Theme.of(context).textTheme.error,
                ),
                Text(
                  "这是错误提示",
                  style: Theme.of(context).textTheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
