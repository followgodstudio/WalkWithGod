import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import '../../widgets/popup_comment.dart';

class BottomBar extends StatelessWidget {
  final String articleId;
  BottomBar(this.articleId);

  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return BottomAppBar(
        child: Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("您可以在此添加想法",
                      style: Theme.of(context).textTheme.captionMedium3),
                ],
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                    context: context,
                    builder: (context, scrollController) => PopUpComment(
                          articleId: articleId,
                          onPressFunc: (String content) {
                            Provider.of<CommentsProvider>(context,
                                    listen: false)
                                .addL1Comment(articleId, content, profile.uid,
                                    profile.name, profile.imageUrl);
                          },
                        ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Theme.of(context).buttonColor),
        ),
      ),
      SizedBox(
        width: 55.0,
        child: FlatButton(
          onPressed: () {},
          child: Icon(
            Icons.share,
            size: 20.0,
          ),
          color: Theme.of(context).buttonColor,
          shape: CircleBorder(),
        ),
      ),
      SizedBox(
        width: 55.0,
        child: FlatButton(
          onPressed: () {},
          child: Icon(
            Icons.star_border,
            size: 20.0,
          ),
          color: Theme.of(context).buttonColor,
          shape: CircleBorder(),
        ),
      ),
    ]));
  }
}