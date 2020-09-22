import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../configurations/theme.dart';
import '../providers/article/comment_provider.dart';
import '../providers/user/profile_provider.dart';
import '../screens/personal_management_screen/headline/network_screen.dart';
import '../utils/utils.dart';
import '../widgets/popup_comment.dart';
import 'popup_dialog.dart';
import 'profile_picture.dart';

class Comment extends StatelessWidget {
  final Function onSubmitComment;
  final bool isInCommentDetail;
  Comment({Key key, this.onSubmitComment, this.isInCommentDetail = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Consumer<CommentProvider>(builder: (context, data, child) {
      final bool isLevel2Comment = (data.parent != null);
      return Column(
        children: [
          SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //avatar and title / created time
            children: [
              // Avatar
              Column(
                children: [
                  ProfilePicture(isLevel2Comment ? 16.0 : 20.0,
                      data.creatorImage, data.creatorUid),
                  // TODO: add a vertical line here
                ],
              ),
              // Others
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    // title / created time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (data.creatorUid == null ||
                                  data.creatorUid.isEmpty) return;
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
                          style: Theme.of(context).textTheme.bodyTextGray,
                        )
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // Comment body
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  if (data.replyToName != null)
                                    TextSpan(
                                        text: "@" + data.replyToName + " ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .captionMedium1,
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            if (data.replyToUid == null ||
                                                data.replyToUid.isEmpty) return;
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
                    // Icons
                    Row(
                      children: [
                        if (!data.like)
                          IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Color.fromARGB(255, 160, 160, 160),
                              ),
                              onPressed: () => data.addLike(
                                  profile.uid, profile.name, profile.imageUrl)),
                        if (data.like)
                          IconButton(
                              icon:
                                  Icon(Icons.favorite, color: Colors.pink[300]),
                              onPressed: () => data.cancelLike(profile.uid)),
                        Text(
                          data.likesCount.toString(),
                          style: Theme.of(context).textTheme.captionMedium1,
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Row(children: [
                            Icon(
                              Icons.comment,
                              color: Color.fromARGB(255, 160, 160, 160),
                            ),
                            Text(
                              " 回复",
                              style: Theme.of(context).textTheme.captionMedium1,
                            )
                          ]),
                          onPressed: () {
                            showMaterialModalBottomSheet(
                                context: context,
                                builder: (context, scrollController) =>
                                    PopUpComment(
                                      articleId: data.articleId,
                                      onPressFunc: (String content) async {
                                        await data.addLevel2Comment(
                                            content,
                                            profile.uid,
                                            profile.name,
                                            profile.imageUrl,
                                            isLevel2Comment);
                                        if (onSubmitComment != null)
                                          await onSubmitComment();
                                        if (isInCommentDetail)
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                });
                                                return PopUpDialog(
                                                    true, "你刚刚发布了留言");
                                              });
                                      },
                                    ));
                          },
                        ),
                      ],
                    ),
                    if (data.childrenCount != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          "共有" + data.childrenCount.toString() + "条回复",
                          style: Theme.of(context).textTheme.buttonMedium1,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          if (!isLevel2Comment) Divider(),
        ],
      );
    });
  }
}
