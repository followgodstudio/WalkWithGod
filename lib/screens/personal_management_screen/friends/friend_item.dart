import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/friend_provider.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/profile_picture.dart';

class FriendItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
        builder: (context, data, child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  ProfilePicture(20.0, data.friendImageUrl, data.friendUid),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(data.friendName,
                          style: Theme.of(context).textTheme.buttonMedium1)),
                  MyTextButton(
                    text: (data.friendStatus == eFriendStatusFollowing)
                        ? "已关注"
                        : (data.friendStatus == eFriendStatusFriend)
                            ? "已互相关注"
                            : "开始关注",
                    isSmall: true,
                    style: (data.friendStatus == eFriendStatusFollowing ||
                            data.friendStatus == eFriendStatusFriend)
                        ? TextButtonStyle.regular
                        : TextButtonStyle.active,
                    onPressed: () {
                      exceptionHandling(context, () async {
                        ProfileProvider profile = Provider.of<ProfileProvider>(
                            context,
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
                  ),
                ],
              ),
            ));
  }
}
