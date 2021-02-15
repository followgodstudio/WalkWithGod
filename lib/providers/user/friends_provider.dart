import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import 'friend_provider.dart';

class FriendsProvider with ChangeNotifier {
  var fdb;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int followingsCount = 0;
  int followersCount = 0;
  List<FriendProvider> _follower = [];
  List<FriendProvider> _following = [];
  DocumentSnapshot _lastVisibleFollower;
  DocumentSnapshot _lastVisibleFollowing;
  bool _noMoreFollower = false;
  bool _noMoreFollowing = false;
  bool _isFetching = false; // To avoid frequently request

  // getters and setters

  void setProvider(dynamic fdb, String userId) {
    this.fdb = fdb;
    this._userId = userId;
  }

  List<FriendProvider> get follower {
    return [..._follower];
  }

  List<FriendProvider> get following {
    return [..._following];
  }

  bool get noMoreFollower {
    return _noMoreFollower;
  }

  bool get noMoreFollowing {
    return _noMoreFollowing;
  }

  // methods

  Future<void> fetchFriendList(bool isFollower, [int limit = loadLimit]) async {
    _logger.i("FriendsProvider-fetchFriendList-" +
        (isFollower ? "follower" : "following"));
    if (isFollower) {
      _follower = [];
    } else {
      _following = [];
    }
    QuerySnapshot query = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(isFollower ? cUserFollowers : cUserFollowings)
        .orderBy(fCreatedDate, descending: true)
        .limit(limit)
        .get();
    _appendFriendsList(query, limit, isFollower);
  }

  Future<void> fetchMoreFriends(bool isFollower,
      [int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
    _logger.i("FriendsProvider-fetchMoreFriends-" +
        (isFollower ? "follower" : "following"));
    DocumentSnapshot lastVisible = _lastVisibleFollowing;
    if (isFollower) {
      lastVisible = _lastVisibleFollower;
    }
    _isFetching = true;
    QuerySnapshot query = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(isFollower ? cUserFollowers : cUserFollowings)
        .orderBy(fCreatedDate, descending: true)
        .startAfterDocument(lastVisible)
        .limit(limit)
        .get();
    _isFetching = false;
    _appendFriendsList(query, limit, isFollower);
  }

  Future<FriendProvider> fetchFriendStatusByUserId(String userId) async {
    _logger.i("FriendsProvider-fetchFriendStatusByUserId");
    DocumentSnapshot follower = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserFollowers)
        .doc(userId)
        .get();
    DocumentSnapshot following = await fdb
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserFollowings)
        .doc(userId)
        .get();
    if (following.exists)
      return _buildFriendByMap(following.id, following.data());
    //TODO: cannot find followers doc here
    if (follower.exists) return _buildFriendByMap(follower.id, follower.data());
    return null;
  }

  Future<void> removefollowInList(String userId) async {
    _logger.i("FriendsProvider-removefollowInList");
    _following.removeWhere((item) => item.friendUid == userId);
    FriendProvider follower = _follower
        .firstWhere((element) => element.friendUid == userId, orElse: () {
      return null;
    });
    if (follower != null) follower.friendStatus = eFriendStatusFollower;
    followingsCount -= 1;
    notifyListeners();
  }

  Future<void> addFollowInList(
    FriendProvider friend,
  ) async {
    _logger.i("FriendsProvider-addFollowInList");
    _following.insert(0, friend);
    FriendProvider follower = _follower.firstWhere(
        (element) => element.friendUid == friend.friendUid, orElse: () {
      return null;
    });
    if (follower != null) follower.friendStatus = eFriendStatusFriend;
    followingsCount += 1;
    notifyListeners();
  }

  void _appendFriendsList(QuerySnapshot query, int limit, bool isFollower) {
    List<DocumentSnapshot> docs = query.docs;
    if (isFollower) {
      docs.forEach((data) {
        _follower.add(_buildFriendByMap(data.id, data.data()));
      });
      if (docs.length < limit) _noMoreFollower = true;
      if (docs.length > 0) _lastVisibleFollower = docs[docs.length - 1];
    } else {
      docs.forEach((data) {
        _following.add(_buildFriendByMap(data.id, data.data()));
      });
      if (docs.length < limit) _noMoreFollowing = true;
      if (docs.length > 0) _lastVisibleFollowing = docs[docs.length - 1];
    }
    notifyListeners();
  }

  FriendProvider _buildFriendByMap(String id, Map<String, dynamic> data) {
    return FriendProvider(
      friendUid: id,
      friendName: data[fFriendName],
      friendImageUrl: data[fFriendImageUrl],
      friendStatus: data[fFriendStatus],
    );
  }
}
