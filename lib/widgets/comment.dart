import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configurations/theme.dart';
import '../providers/article/comment_provider.dart';
import '../providers/user/profile_provider.dart';
import '../screens/personal_management_screen/headline/network_screen.dart';
import '../utils/utils.dart';
import '../widgets/popup_comment.dart';
import 'my_icon_button.dart';
import 'profile_picture.dart';

class Comment extends StatelessWidget {
  final Function onStartComment;
  final Function onSubmitComment;
  final bool showIconButton;
  Comment(
      {Key key,
      this.onStartComment,
      this.onSubmitComment,
      this.showIconButton = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    double iconSize = 18.0;
    double iconSpacing = 60.0;
    return Consumer<CommentProvider>(builder: (context, data, child) {
      final bool isLevel2Comment = (data.parent != null);
      return Column(
        children: [
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //avatar and title / created time
            children: [
              // Avatar
              Column(
                children: [
                  SizedBox(height: 3.0),
                  ProfilePicture(15.0, data.creatorImage, data.creatorUid),
                ],
              ),
              // Others
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    // title / created time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (data.creatorUid == null) return;
                              Navigator.of(context).pushNamed(
                                NetworkScreen.routeName,
                                arguments: data.creatorUid,
                              );
                            },
                            child: Text(
                              data.creatorName,
                              style: Theme.of(context).textTheme.captionMedium1,
                            )),
                        Text(
                          getCreatedDuration(data.createdDate),
                          style: Theme.of(context).textTheme.captionMedium2,
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                    // Comment body
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          VerticalDivider(
                            indent: 4,
                            thickness: 1.2,
                            color: MyColors.lightGrey,
                            width: 1.2,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    if (data.replyToName != null)
                                      TextSpan(
                                          text: "@" + data.replyToName + ": ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () {
                                              if (data.replyToUid == null ||
                                                  data.replyToUid.isEmpty)
                                                return;
                                              Navigator.of(context).pushNamed(
                                                  NetworkScreen.routeName,
                                                  arguments: data.replyToUid);
                                            }),
                                    TextSpan(
                                      text: data.content,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    if (!showIconButton)
                      Row(children: [
                        Text(data.likesCount.toString() + "个赞",
                            style: Theme.of(context).textTheme.captionMedium2),
                        SizedBox(width: iconSpacing),
                        Text(data.childrenCount.toString() + "条回复",
                            style: Theme.of(context).textTheme.captionMedium2),
                      ]),
                    // Icons
                    if (showIconButton)
                      Row(
                        children: [
                          if (profile.uid == null || !data.like)
                            MyIconButton(
                                label: data.likesCount.toString(),
                                iconSize: iconSize,
                                icon: 'heart_border',
                                onPressed: () {
                                  if (profile.uid == null) {
                                    showPopUpDialog(context, false, "请登录后再操作");
                                  } else {
                                    data.addLike(profile.uid, profile.name,
                                        profile.imageUrl);
                                  }
                                }),
                          if (profile.uid != null && data.like)
                            MyIconButton(
                                label: data.likesCount.toString(),
                                iconSize: iconSize,
                                icon: 'heart',
                                iconColor: MyColors.pink,
                                onPressed: () {
                                  data.cancelLike(profile.uid);
                                }),
                          SizedBox(width: iconSpacing),
                          MyIconButton(
                              iconSize: iconSize,
                              icon: 'comment',
                              label: data.childrenCount != null
                                  ? data.childrenCount.toString()
                                  : "回复",
                              onPressed: () async {
                                if (profile.uid == null) {
                                  showPopUpDialog(context, false, "请登录后再操作");
                                } else {
                                  int timeLag;
                                  if (onStartComment != null) {
                                    timeLag = 200;
                                    await onStartComment();
                                  }
                                  if (!isLevel2Comment &&
                                      data.childrenCount != null &&
                                      data.childrenCount > 0) return;
                                  Function showAddCommentPage =
                                      () => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => PopUpComment(
                                                isReply: true,
                                                replyTo: isLevel2Comment
                                                    ? data.creatorName
                                                    : null,
                                                articleId: data.articleId,
                                                onPressFunc:
                                                    (String content) async {
                                                  await data.addLevel2Comment(
                                                      content,
                                                      profile.uid,
                                                      profile.name,
                                                      profile.imageUrl,
                                                      isLevel2Comment);
                                                  if (onSubmitComment != null)
                                                    await onSubmitComment();
                                                },
                                              ));
                                  if (timeLag != null) {
                                    Timer(Duration(milliseconds: timeLag), () {
                                      showAddCommentPage();
                                    });
                                  } else {
                                    showAddCommentPage();
                                  }
                                }
                              }),
                        ],
                      ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
          if (!isLevel2Comment) Divider(),
        ],
      );
    });
  }
}
