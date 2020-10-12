import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/profile_picture.dart';

class FriendItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
        builder: (context, data, child) => Column(children: [
              Row(
                children: [
                  ProfilePicture(20.0, data.friendImageUrl, data.friendUid),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(data.friendName,
                          style: Theme.of(context).textTheme.buttonMedium1)),
                  FlatButton(
                      onPressed: () {
                        exceptionHandling(context, () async {
                          ProfileProvider profile =
                              Provider.of<ProfileProvider>(context,
                                  listen: false);
                          if (data.friendStatus == eFriendStatusFollowing ||
                              data.friendStatus == eFriendStatusFriend) {
                            await data.unfollow(
                                profile.uid, profile.name, profile.imageUrl);
                            await profile.friendsProvider
                                .removefollowInList(data.friendUid);
                          } else {
                            await data.follow(
                                profile.uid, profile.name, profile.imageUrl);
                            await profile.friendsProvider.addFollowInList(data);
                          }
                        });
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
