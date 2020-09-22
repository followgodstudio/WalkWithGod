import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class FriendProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
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

  // will be called by friends_provider
  Future<void> follow(String uid, String name, String imageUrl) async {
    if (friendStatus == eFriendStatusFollowing ||
        friendStatus == eFriendStatusFriend) return;
    DateTime followingDate = DateTime.now();
    friendStatus = (friendStatus == eFriendStatusFollower)
        ? eFriendStatusFriend
        : eFriendStatusFollowing;
    notifyListeners();

    // Update remote database
    WriteBatch batch = _db.batch();

    // Update current user's document
    batch.set(
        _db.collection(cUsers).doc(uid).collection(cUserFriends).doc(friendUid),
        {
          fFriendName: friendName,
          fFriendImageUrl: friendImageUrl,
          fFriendFollowingDate: Timestamp.fromDate(followingDate),
          fFriendStatus: friendStatus
        },
        SetOptions(merge: true));

    // Update followed user's document
    batch.set(
        _db.collection(cUsers).doc(friendUid).collection(cUserFriends).doc(uid),
        {
          fFriendName: name,
          fFriendImageUrl: imageUrl,
          fFriendFollowerDate: Timestamp.fromDate(followingDate),
          fFriendStatus: (friendStatus == eFriendStatusFriend
              ? eFriendStatusFriend
              : eFriendStatusFollower)
        },
        SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> unfollow(String uid, String name, String imageUrl) async {
    if (friendStatus != eFriendStatusFollowing &&
        friendStatus != eFriendStatusFriend) return;
    friendStatus =
        (friendStatus == eFriendStatusFriend) ? eFriendStatusFollower : null;
    notifyListeners();

    // Update remote database
    WriteBatch batch = _db.batch();

    if (friendStatus != null) {
      // They were friends
      batch.set(
          _db
              .collection(cUsers)
              .doc(uid)
              .collection(cUserFriends)
              .doc(friendUid),
          {fFriendStatus: friendStatus},
          SetOptions(merge: true));
      batch.set(
          _db
              .collection(cUsers)
              .doc(friendUid)
              .collection(cUserFriends)
              .doc(uid),
          {fFriendStatus: eFriendStatusFollowing},
          SetOptions(merge: true));
    } else {
      batch.delete(_db
          .collection(cUsers)
          .doc(uid)
          .collection(cUserFriends)
          .doc(friendUid));
      batch.delete(_db
          .collection(cUsers)
          .doc(friendUid)
          .collection(cUserFriends)
          .doc(uid));
    }
    await batch.commit();
  }
}
