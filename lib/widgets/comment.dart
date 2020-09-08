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
import 'profile_picture.dart';

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Consumer<CommentProvider>(
      builder: (context, data, child) => Column(
        children: [
          SizedBox(height: 8.0),
          Row(
            //avatar and title / created time
            children: [
              ProfilePicture(data.creatorImage, 20.0, data.creatorUid),
              Column(
                //title and time
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
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
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          getStringByDate(data.createdDate),
                          style: Theme.of(context).textTheme.captionSmall1,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 60,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        if (data.replyToName != null)
                          TextSpan(
                              text: "@" + data.replyToName + ": ",
                              style: Theme.of(context).textTheme.bodyText4,
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
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              if (!data.like)
                IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () => data.addLike(
                        profile.uid, profile.name, profile.imageUrl)),
              if (data.like)
                IconButton(
                    icon: Icon(Icons.favorite, color: Colors.pink[300]),
                    onPressed: () => data.cancelLike(profile.uid)),
              Text(
                data.likesCount.toString(),
                style: Theme.of(context).textTheme.overline,
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  showMaterialModalBottomSheet(
                      context: context,
                      builder: (context, scrollController) => PopUpComment(
                            articleId: data.articleId,
                            onPressFunc: (String content) {
                              data.addL2Comment(
                                  content,
                                  profile.uid,
                                  profile.name,
                                  profile.imageUrl,
                                  (data.parent != null));
                            },
                          ));
                },
              ),
              if (data.childrenCount != null)
                Text(
                  data.childrenCount.toString(),
                  style: Theme.of(context).textTheme.overline,
                )
            ],
          ),
          Divider(
            color: Color.fromARGB(255, 128, 128, 128),
          ),
        ],
      ),
    );
  }
}
