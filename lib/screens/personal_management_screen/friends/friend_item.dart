import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/configurations/constants.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../widgets/profile_picture.dart';

class FriendItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
        builder: (context, data, child) => Column(children: [
              Row(
                children: [
                  ProfilePicture(data.friendImageUrl, 20.0, data.friendUid),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(data.friendName,
                          style: Theme.of(context).textTheme.buttonMedium1)),
                  FlatButton(
                      onPressed: () {
                        if (data.friendStatus == eFriendStatusFollowing ||
                            data.friendStatus == eFriendStatusFriend) {
                          data.unfollow();
                        } else {
                          data.follow();
                        }
                      },
                      child: Text(
                          (data.friendStatus == eFriendStatusFollowing)
                              ? "已关注"
                              : (data.friendStatus == eFriendStatusFriend)
                                  ? "已互相关注"
                                  : "开始关注",
                          style: (data.friendStatus == eFriendStatusFollowing ||
                                  data.friendStatus == eFriendStatusFriend)
                              ? Theme.of(context).textTheme.bodyText2
                              : Theme.of(context).textTheme.bodyTextWhite),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: (data.friendStatus == eFriendStatusFollowing ||
                              data.friendStatus == eFriendStatusFriend)
                          ? Theme.of(context).buttonColor
                          : Colors.blue),
                ],
              ),
            ]));
  }
}