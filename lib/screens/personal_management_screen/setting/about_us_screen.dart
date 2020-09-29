import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/setting_provider.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text('关于我们', style: Theme.of(context).textTheme.captionMedium2),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("我们是谁",
                        style: Theme.of(context).textTheme.captionMedium1),
                  ),
                  Text(
                      Provider.of<SettingProvider>(context, listen: false)
                          .whoAreWe,
                      style: Theme.of(context).textTheme.bodyTextBlack),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("我们的使命",
                        style: Theme.of(context).textTheme.captionMedium1),
                  ),
                  Text(
                      Provider.of<SettingProvider>(context, listen: false)
                          .ourMission,
                      style: Theme.of(context).textTheme.bodyTextBlack),
                ],
              )),
        )));
  }
}
