import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class FriendProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;
  final String name;
  final String imageUrl;
  final String friendUid;
  final String friendName;
  final String friendImageUrl;
  String friendStatus;

  FriendProvider({
    @required this.uid,
    @required this.name,
    @required this.imageUrl,
    this.friendUid,
    this.friendName,
    this.friendImageUrl,
    this.friendStatus,
  });

  // will be called by friends_provider
  Future<void> follow() async {
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
        SetOptions(merge: true)
        //merge: true
        );
    // Update following count
    batch.update(_db.collection(cUsers).doc(uid),
        {fUserFollowingsCount: FieldValue.increment(1)});

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
        SetOptions(merge: true)
        //merge: true
        );
    // Update follower count
    batch.update(_db.collection(cUsers).doc(friendUid),
        {fUserFollowersCount: FieldValue.increment(1)});

    await batch.commit();
  }

  Future<void> unfollow() async {
    if (friendStatus != eFriendStatusFollowing &&
        friendStatus != eFriendStatusFriend) return;
    friendStatus =
        (friendStatus == eFriendStatusFriend) ? eFriendStatusFollower : null;
    notifyListeners();

    // Update remote database
    WriteBatch batch = _db.batch();

    // Update current user's document
    if (friendStatus != null) {
      batch.set(
          _db
              .collection(cUsers)
              .doc(uid)
              .collection(cUserFriends)
              .doc(friendUid),
          {fFriendStatus: friendStatus},
          SetOptions(merge: true)
          //merge: true
          );
    } else {
      batch.delete(_db
          .collection(cUsers)
          .doc(uid)
          .collection(cUserFriends)
          .doc(friendUid));
    }
    // Update following count
    batch.update(_db.collection(cUsers).doc(uid),
        {fUserFollowingsCount: FieldValue.increment(-1)});

    // Update followed user's document
    if (friendStatus != null) {
      batch.set(
          _db
              .collection(cUsers)
              .doc(friendUid)
              .collection(cUserFriends)
              .doc(uid),
          {fFriendStatus: eFriendStatusFollowing},
          SetOptions(merge: true)
          //merge: true
          );
    } else {
      batch.delete(_db
          .collection(cUsers)
          .doc(friendUid)
          .collection(cUserFriends)
          .doc(uid));
    }
    // Update follower count
    batch.update(_db.collection(cUsers).doc(friendUid),
        {fUserFollowersCount: FieldValue.increment(-1)});

    await batch.commit();
  }
}
