import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/article/article_provider.dart';
import '../providers/article/articles_provider.dart';
import '../providers/article/comment_provider.dart';
import '../providers/article/comments_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user/message_provider.dart';
import '../providers/user/messages_provider.dart';

// This screen is used to test the providers

class TestScreen extends StatelessWidget {
  static const routeName = '/test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test Personal Management'),
          backgroundColor: Color(0),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          TestLogout(),
          TestComments(),
          // TestArticles(),
          TestMessages(),
        ])));
  }
}

class TestComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String aid = "MeaMCcvB8mImA3nSravA";
    String uid = "M5gGDuUfcHV02fzuMMQBA7z2oJa2";
    String userName = "彭兔香";
    String userImage = "https://photo.sohu.com/88/60/Img214056088.jpg";
    return Column(
      children: [
        RaisedButton(
            child: Text("Comment"),
            onPressed: () {
              Provider.of<CommentsProvider>(context, listen: false)
                  .addL1Comment(aid, "这是一段留言", uid, userName, userImage);
            }),
        FutureBuilder(
          future: Provider.of<CommentsProvider>(context, listen: false)
              .fetchL1CommentListByAid(aid),
          builder: (ctx, _) =>
              Consumer<CommentsProvider>(builder: (context, data, child) {
            List<CommentProvider> commentProvider = data.items;
            if (commentProvider.length > 0) {
              List<Widget> list = [];
              for (var i = 0; i < commentProvider.length; i++) {
                list.add(ChangeNotifierProvider.value(
                  value: commentProvider[i],
                  child: TestComment(),
                ));
              }
              return Column(children: list);
            } else {
              return Text("None...");
            }
          }),
        ),
      ],
    );
  }
}

class TestComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = "2xxmzDxLnUP97GBX2flyi2JfhGF2";
    String userName = "凯瑟琳";
    String userImage = "https://photo.sohu.com/88/60/Img214056088.jpg";
    return Consumer<CommentProvider>(
        builder: (context, data, child) => Column(children: [
              Text("ID: " + data.id),
              Text(data.creatorName + ":" + data.content),
              // Text(data.createDate.toIso8601String()),
              Row(children: [
                Text("Reply: " + data.childrenCount.toString()),
                RaisedButton(
                    child: Text("Reply"),
                    onPressed: () {
                      Provider.of<CommentProvider>(context, listen: false)
                          .addL2Comment("你说的对", uid, userName, userImage);
                    }),
              ]),
              Row(
                children: [
                  Text("Like: " + data.likesCount.toString()),
                  RaisedButton(
                      child: Text("Like"),
                      onPressed: () async {
                        await Provider.of<CommentProvider>(context,
                                listen: false)
                            .addLike(uid, userName, userImage);
                      }),
                  RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () async {
                        await Provider.of<CommentProvider>(context,
                                listen: false)
                            .cancelLike(uid);
                      }),
                ],
              ),
            ]));
  }
}

class TestArticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> aids = ["G45Cl5lT5txWANROo7XY"];
    return FutureBuilder(
      future:
          Provider.of<ArticlesProvider>(context, listen: false).fetchList(aids),
      builder: (ctx, _) =>
          Consumer<ArticlesProvider>(builder: (context, data, child) {
        if (data.articles.length > 0) {
          List<Widget> list = [];
          for (var i = 0; i < data.articles.length; i++) {
            list.add(ChangeNotifierProvider.value(
              value: data.articles[i],
              child: TestArticle(),
            ));
          }
          return Column(children: list);
        } else {
          return Text("None...");
        }
      }),
    );
  }
}

class TestArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
        builder: (context, data, child) => Column(children: [
              Text("Article:"),
              Text(data.title),
              Text(data.author),
            ]));
  }
}

class TestMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = "M5gGDuUfcHV02fzuMMQBA7z2oJa2";
    return Column(
      children: [
        Text("Messages:"),
        FutureBuilder(
            future: Provider.of<MessagesProvider>(context, listen: false)
                .fetchMessageListByUserId(uid),
            builder: (ctx, _) =>
                Consumer<MessagesProvider>(builder: (context, data, child) {
                  if (data.items.length > 0) {
                    List<Widget> list = [];
                    for (var i = 0; i < data.items.length; i++) {
                      list.add(ChangeNotifierProvider.value(
                        value: data.items[i],
                        child: TestMessage(),
                      ));
                    }
                    return Column(children: list);
                  } else {
                    return Text("None...");
                  }
                }))
      ],
    );
  }
}

class TestMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
        builder: (context, data, child) => Row(children: [
              Text(DateFormat("MM-dd hh:mm").format(data.createDate)),
              Text(" " + data.senderName + " " + data.type),
            ]));
  }
}

class TestLogout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    return Consumer<AuthProvider>(
        builder: (context, data, child) => Column(children: [
              Text("User ID:"),
              Text(userId != null ? userId : ""),
              FlatButton(
                child: Row(children: <Widget>[
                  Icon(Icons.exit_to_app),
                  Text('Logout')
                ]),
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ]));
  }
}
