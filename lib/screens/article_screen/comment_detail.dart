import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/article/comment_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/comment.dart';
import '../../widgets/my_bottom_indicator.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/popup_comment.dart';
import '../../widgets/popup_login.dart';

class CommentDetail extends StatefulWidget {
  @override
  _CommentDetailState createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final _controller = ScrollController();

  void onSubmitComment() {
    _controller.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
    showPopUpDialog(context, true, "你刚刚发布了回复");
  }

  @override
  Widget build(BuildContext context) {
    String _userId = Provider.of<ProfileProvider>(context, listen: false).uid;
    return Container(
        height: 0.9 * MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
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
                          child: Comment(showIconButton: false),
                          builder: (context, data, child) {
                            List<Widget> list = [];
                            list.add(child);
                            if (data.childrenCount == 0) {
                              list.add(Center(
                                  child: Text("暂无回复",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .captionMedium2)));
                              return Column(children: list);
                            }
                            for (var i = 0; i < data.children.length; i++) {
                              list.add(ChangeNotifierProvider.value(
                                value: data.children[i],
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Comment(
                                        onSubmitComment: onSubmitComment)),
                              ));
                            }
                            list.add(Divider());
                            list.add(MyBottomIndicator(data.noMoreChild));
                            return Column(children: list);
                          }),
                    )),
              ),
            ),
            CommentBottomBar(onSubmitComment),
          ],
        ));
  }
}

class CommentBottomBar extends StatelessWidget {
  final Function onSubmitComment;
  CommentBottomBar(this.onSubmitComment);
  @override
  Widget build(BuildContext context) {
    final bottomBarHeight = 40.0;
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    CommentProvider comment =
        Provider.of<CommentProvider>(context, listen: false);
    return Column(
      children: [
        MyDivider(),
        Row(children: [
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: bottomBarHeight,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("您可以在此添加回复",
                          style: Theme.of(context).textTheme.captionMedium2),
                    ],
                  ),
                  onPressed: () {
                    if (profile.uid == null) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PopupLogin(),
                      );
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => PopUpComment(
                                isReply: true,
                                articleId: comment.articleId,
                                onPressFunc: (String content) async {
                                  await comment.addLevel2Comment(
                                      content,
                                      profile.uid,
                                      profile.name,
                                      profile.imageUrl,
                                      false);
                                  onSubmitComment();
                                },
                              ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(bottomBarHeight / 2),
                    ),
                    primary: Theme.of(context).buttonColor,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Consumer<CommentProvider>(builder: (context, data, child) {
            if (profile.uid == null || !data.like) {
              return MyIconButton(
                  hasBorder: true,
                  icon: 'heart_border',
                  onPressed: () {
                    if (profile.uid == null) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PopupLogin(),
                      );
                    } else {
                      data.addLike(profile.uid, profile.name, profile.imageUrl);
                    }
                  });
            } else {
              return MyIconButton(
                  hasBorder: true,
                  icon: 'heart',
                  buttonColor: MyColors.pink,
                  iconColor: Colors.white,
                  onPressed: () {
                    data.cancelLike(profile.uid);
                  });
            }
          }),
          SizedBox(width: 15.0),
        ]),
      ],
    );
  }
}
