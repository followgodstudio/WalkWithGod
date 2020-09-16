import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/comment.dart';
import '../../widgets/succeeded_dialog.dart';

class CommentDetail extends StatefulWidget {
  final String articleId;
  final CommentProvider commentProvider;
  final bool afterSubmit;
  CommentDetail(
      {this.articleId, this.commentProvider, this.afterSubmit = false});

  @override
  _CommentDetailState createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    if (widget.afterSubmit)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pop(true);
              });
              return SucceededDialog("你刚刚发布了留言");
            });
      });
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.easeIn);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<ProfileProvider>(context, listen: false).uid;
    return Container(
        height: 0.85 * MediaQuery.of(context).size.height,
        child: ChangeNotifierProvider.value(
            value: widget.commentProvider,
            child: Builder(builder: (BuildContext context) {
              BuildContext rootContext = context;
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    Provider.of<CommentProvider>(rootContext, listen: false)
                        .fetchMoreL2ChildrenComments(_userId);
                  }
                  return true;
                },
                child: SingleChildScrollView(
                    controller: _controller,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Consumer<CommentProvider>(
                          builder: (context, data, child) {
                        List<Widget> list = [];
                        list.add(Comment());
                        if (data.childrenCount == 0) {
                          list.add(Center(
                              child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("暂无回复",
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.captionMedium3),
                          )));
                          return Column(children: list);
                        }
                        for (var i = 0; i < data.children.length; i++) {
                          list.add(ChangeNotifierProvider.value(
                            value: data.children[i],
                            child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Comment(onSubmitComment: null)),
                          ));
                        }
                        list.add(Divider());
                        list.add(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data.noMoreChild ? "到底啦" : "加载更多",
                              style:
                                  Theme.of(context).textTheme.captionMedium3),
                        ));
                        return Column(children: list);
                      }),
                    )),
              );
            })));
  }
}
