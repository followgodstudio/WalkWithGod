import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/messages_provider.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/navbar.dart';
import 'message_item.dart';

class MessagesListScreen extends StatelessWidget {
  static const routeName = '/messages_list';
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: NavBar(title: "我的消息"),
        body: SafeArea(
            child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              exceptionHandling(context, () async {
                await profile.messagesProvider.fetchMoreMessages();
              });
            }
            return true;
          },
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: exceptionHandling(context, () async {
                    await profile.messagesProvider
                        .fetchMessageList(profile.messagesCount);
                  }),
                  builder: (ctx, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) return MyProgressIndicator();
                    return Consumer<MessagesProvider>(
                        builder: (context, data, child) {
                      if (data.items.length == 0) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: verticalPadding),
                            child: Text("暂无消息",
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.captionMedium2),
                          ),
                        );
                      }
                      List<Widget> list = [];
                      list.add(SizedBox(
                        height: 10.0,
                      ));
                      for (var i = 0; i < data.items.length; i++) {
                        list.add(ChangeNotifierProvider.value(
                          value: data.items[i],
                          child: MessageItem(),
                        ));
                      }

                      list.add(Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data.noMore ? "到底啦" : "加载更多",
                            style: Theme.of(context).textTheme.captionMedium2),
                      ));
                      return Column(children: list);
                    });
                  })),
        )));
  }
}
