import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/user/profile_provider.dart';
import '../headline/introduction.dart';

class NetworkScreen extends StatelessWidget {
  static const routeName = '/network';
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
        body: SafeArea(
            child: FutureBuilder(
                future: Provider.of<ProfileProvider>(context, listen: false)
                    .fetchProfileByUid(uid),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (asyncSnapshot.error != null)
                    return Center(child: Text('An error occurred!'));
                  ProfileProvider profile = asyncSnapshot.data;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: <Widget>[
                        Introduction(profile.name, profile.imageUrl),
                        Divider(color: Color.fromARGB(255, 128, 128, 128)),
                      ]),
                    ),
                  );
                })));
  }
}
