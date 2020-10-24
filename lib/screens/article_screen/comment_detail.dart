import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/comment.dart';

class CommentDetail extends StatefulWidget {
  final String articleId;
  final CommentProvider commentProvider;
  CommentDetail({this.articleId, this.commentProvider});

  @override
  _CommentDetailState createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final _controller = ScrollController();

  void onSubmitComment() {
    _controller.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
    showPopUpDialog(context, true, "你刚刚发布了留言");
  }

  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<ProfileProvider>(context, listen: false).uid;
    return Container(
        height: 0.9 * MediaQuery.of(context).size.height,
        child: ChangeNotifierProvider.value(
            value: widget.commentProvider,
            child: Builder(
                builder: (BuildContext context) =>
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          Provider.of<CommentProvider>(context, listen: false)
                              .fetchMoreLevel2ChildrenComments(_userId);
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                          controller: _controller,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: verticalPadding),
                            child: Consumer<CommentProvider>(
                                child: Comment(),
                                builder: (context, data, child) {
                                  List<Widget> list = [];
                                  list.add(child);
                                  if (data.childrenCount == 0) {
                                    list.add(Center(
                                        child: Text("暂无回复",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .captionMedium3)));
                                    return Column(children: list);
                                  }
                                  for (var i = 0;
                                      i < data.children.length;
                                      i++) {
                                    list.add(ChangeNotifierProvider.value(
                                      value: data.children[i],
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40.0),
                                          child: Comment(
                                              onSubmitComment:
                                                  onSubmitComment)),
                                    ));
                                  }
                                  list.add(Divider());
                                  list.add(Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        data.noMoreChild ? "到底啦" : "加载更多",
                                        style: Theme.of(context)
                                            .textTheme
                                            .captionMedium3),
                                  ));
                                  return Column(children: list);
                                }),
                          )),
                    ))));
  }
}
