import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';

class FriendProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  MyLogger _logger = MyLogger("Provider");
  final String friendUid;
  final String friendName;
  final String friendImageUrl;
  String friendStatus;

  FriendProvider({
    @required this.friendUid,
    @required this.friendName,
    @required this.friendImageUrl,
    this.friendStatus,
  });

  Future<void> follow(String userId) async {
    _logger.i("FriendProvider-follow");
    friendStatus = (friendStatus == eFriendStatusFollower)
        ? eFriendStatusFriend
        : eFriendStatusFollowing;
    notifyListeners();
    _db
        .collection(cUsers)
        .doc(userId)
        .collection(cUserFollowings)
        .doc(friendUid)
        .set({
      fFriendName: friendName,
      fFriendImageUrl: friendImageUrl,
      fCreatedDate: Timestamp.fromDate(DateTime.now()),
      fFriendStatus: friendStatus
    }, SetOptions(merge: true));
  }

  Future<void> unfollow(String userId) async {
    _logger.i("FriendProvider-unfollow");
    friendStatus = null;
    notifyListeners();
    _db
        .collection(cUsers)
        .doc(userId)
        .collection(cUserFollowings)
        .doc(friendUid)
        .delete();
  }
}
