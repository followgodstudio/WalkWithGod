import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../providers/article/comment_provider.dart';
import '../providers/user/profile_provider.dart';
import '../widgets/popup_comment.dart';

// TODO: add personal info screen link to the names/images
class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
      child: Consumer<CommentProvider>(
        builder: (context, data, child) => Column(
          children: [
            Row(
              //avatar and title / created time
              children: [
                Column(
                  //avatar
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data.creatorImage),
                      backgroundColor: Colors.brown.shade800,
                    )
                  ],
                ),
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
                        Text(
                          data.creatorName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
                            DateFormat('yyyy-MM-dd H:m:s')
                                .format(data.createdDate),
                            style: Theme.of(context).textTheme.overline,
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
                    child: Text(
                      (data.replyToName == null
                              ? ""
                              : "@" + data.replyToName + ": ") +
                          data.content,
                      style: Theme.of(context).textTheme.bodyText2,
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
      ),
    );
  }
}
