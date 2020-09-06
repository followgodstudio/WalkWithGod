import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';

class FriendProvider with ChangeNotifier {
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
    notifyListeners(); //???
    Map<String, dynamic> data = {};
    data[fFriendName] = friendName;
    data[fFriendImageUrl] = friendImageUrl;
    data[fFriendFollowingDate] = Timestamp.fromDate(followingDate);
    data[fFriendStatus] = friendStatus;
    // Update current user's document
    await Firestore.instance
        .collection(cUsers)
        .document(uid)
        .collection(cUserFriends)
        .document(friendUid)
        .setData(data, merge: true);
    // Update following count
    await Firestore.instance
        .collection(cUsers)
        .document(uid)
        .updateData({fUserFollowingsCount: FieldValue.increment(1)});
    data = {};
    data[fFriendName] = name;
    data[fFriendImageUrl] = imageUrl;
    data[fFriendFollowerDate] = Timestamp.fromDate(followingDate);
    data[fFriendStatus] = friendStatus == eFriendStatusFollower
        ? eFriendStatusFriend
        : eFriendStatusFollower;
    // Update followed user's document
    await Firestore.instance
        .collection(cUsers)
        .document(friendUid)
        .collection(cUserFriends)
        .document(uid)
        .setData(data, merge: true);
    // Update follower count
    await Firestore.instance
        .collection(cUsers)
        .document(friendUid)
        .updateData({fUserFollowersCount: FieldValue.increment(1)});
  }

  Future<void> unfollow() async {
    if (friendStatus != eFriendStatusFollowing &&
        friendStatus != eFriendStatusFriend) return;
    friendStatus =
        (friendStatus == eFriendStatusFriend) ? eFriendStatusFollower : null;
    notifyListeners();
    // Update current user's document
    if (friendStatus != null) {
      Map<String, dynamic> data = {};
      data[fFriendStatus] = friendStatus;
      data[fFriendFollowingDate] = null; //???
      await Firestore.instance
          .collection(cUsers)
          .document(uid)
          .collection(cUserFriends)
          .document(friendUid)
          .setData(data, merge: true);
    } else {
      await Firestore.instance
          .collection(cUsers)
          .document(uid)
          .collection(cUserFriends)
          .document(friendUid)
          .delete();
    }
    // Update following count
    await Firestore.instance
        .collection(cUsers)
        .document(uid)
        .updateData({fUserFollowingsCount: FieldValue.increment(-1)});
    // Update followed user's document
    if (friendStatus != null) {
      Map<String, dynamic> data = {};
      data[fFriendStatus] = eFriendStatusFollowing;
      data[fFriendFollowerDate] = null; //???
      await Firestore.instance
          .collection(cUsers)
          .document(friendUid)
          .collection(cUserFriends)
          .document(uid)
          .setData(data, merge: true);
    } else {
      await Firestore.instance
          .collection(cUsers)
          .document(friendUid)
          .collection(cUserFriends)
          .document(uid)
          .delete();
    }
    // Update follower count
    await Firestore.instance
        .collection(cUsers)
        .document(friendUid)
        .updateData({fUserFollowersCount: FieldValue.increment(-1)});
  }
}
