import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../configurations/constants.dart';
import '../../providers/user/profile_provider.dart';
import 'headline/edit_profile_screen.dart';
import 'headline/introduction.dart';
import 'messages/messages_list_screen.dart';
import 'network/network_screen.dart';
// import 'friend/friendship.dart';
// import 'posts/saved_posts.dart';
// import 'read/reading.dart';

class PersonalManagementScreen extends StatelessWidget {
  static const routeName = '/personal_management';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('我的', style: Theme.of(context).textTheme.headline2),
          elevation: 0,
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
                    .fetchMyProfile(),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (asyncSnapshot.error != null)
                    return Center(child: Text('An error occurred!'));
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: <Widget>[
                        HeadLine(),
                        Divider(color: Color.fromARGB(255, 128, 128, 128)),
                        // Friendship(),
                        // Reading(),
                        // SavedPosts(),
                        Messages(),
                        Divider(color: Color.fromARGB(255, 128, 128, 128)),
                      ]),
                    ),
                  );
                })));
  }
}

class HeadLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            NetworkScreen.routeName,
            arguments: Provider.of<ProfileProvider>(context, listen: false).uid,
          );
        },
        child: Column(
          children: [
            Consumer<ProfileProvider>(
                builder: (ctx, profile, _) =>
                    Introduction("你好，" + profile.name, profile.imageUrl)),
            SizedBox(height: 8.0),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                },
                child: Text("编辑个人资料",
                    style: Theme.of(context).textTheme.captionMedium4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).buttonColor),
          ],
        ));
  }
}

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<ProfileProvider>(context, listen: false)
            .fetchProfileStream(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.active)
            return Center(child: CircularProgressIndicator());
          return FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(MessagesListScreen.routeName);
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "我的消息",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "共" +
                              snapshot.data[fUserMessagesCount].toString() +
                              "条消息, " +
                              snapshot.data[fUserUnreadMsgCount].toString() +
                              "条未读",
                          style: Theme.of(context).textTheme.captionMain,
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 20.0, color: Color.fromARGB(255, 128, 128, 128)),
              ],
            ),
          );
        });
  }
}
