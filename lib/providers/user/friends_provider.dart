import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import '../../utils/my_logger.dart';
import 'friend_provider.dart';

class FriendsProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
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

  void setUserId(String userId) {
    _userId = userId;
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

  Future<void> fetchFriendList(bool isFollower,
      [int newFollowersCount, int limit = loadLimit]) async {
    List<String> whereIn = [eFriendStatusFollowing, eFriendStatusFriend];
    String orderBy = fFriendFollowingDate;
    if (isFollower) {
      if (followersCount == newFollowersCount) return; // Do not need update
      whereIn = [eFriendStatusFollower, eFriendStatusFriend];
      orderBy = fFriendFollowerDate;
      _follower = [];
    } else {
      _following = [];
    }
    _logger.i("FriendsProvider-fetchFriendList-" +
        (isFollower ? "follower" : "following"));
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserFriends)
        .where(fFriendStatus, whereIn: whereIn)
        .orderBy(orderBy, descending: true)
        .limit(limit)
        .get();
    _appendFriendsList(query, limit, isFollower);
  }

  Future<void> fetchMoreFriends(bool isFollower,
      [int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
    _logger.i("FriendsProvider-fetchMoreFriends");
    List<String> whereIn = [eFriendStatusFollowing, eFriendStatusFriend];
    String orderBy = fFriendFollowingDate;
    DocumentSnapshot lastVisible = _lastVisibleFollowing;
    if (isFollower) {
      whereIn = [eFriendStatusFollower, eFriendStatusFriend];
      orderBy = fFriendFollowerDate;
      lastVisible = _lastVisibleFollower;
    }
    _isFetching = true;
    QuerySnapshot query = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserFriends)
        .orderBy(fCreatedDate, descending: true)
        .where(fFriendStatus, whereIn: whereIn)
        .orderBy(orderBy, descending: true)
        .startAfterDocument(lastVisible)
        .limit(limit)
        .get();
    _isFetching = false;
    _appendFriendsList(query, limit, isFollower);
  }

  Future<FriendProvider> fetchFriendStatusByUserId(String userId) async {
    _logger.i("FriendsProvider-fetchFriendStatusByUserId");
    DocumentSnapshot doc = await _db
        .collection(cUsers)
        .doc(_userId)
        .collection(cUserFriends)
        .doc(userId)
        .get();
    if (doc.exists) return _buildFriendByMap(doc.id, doc.data());
    return null;
  }

  Future<void> refreshFollowingList() async {
    _following.removeWhere((item) =>
        (item.friendStatus != eFriendStatusFollowing &&
            item.friendStatus != eFriendStatusFriend));
  }

  Future<void> removefollowInList(String userId) async {
    // _following.removeWhere((item) => item.friendUid == userId);
    // FriendProvider friend = _follower
    //     .firstWhere((element) => element.friendUid == userId, orElse: () {
    //   return null;
    // });
    // if (friend != null) friend.friendStatus = eFriendStatusFollower;
    // followingsCount -= 1;
    // notifyListeners();

    _logger.i("FriendsProvider-removefollowInList");
    // Update database
    WriteBatch batch = _db.batch();
    batch.update(
        _db
            .collection(cUsers)
            .doc(_userId)
            .collection(cUserProfile)
            .doc(dUserProfileStatic),
        {fUserFollowingsCount: FieldValue.increment(-1)});
    batch.update(
        _db
            .collection(cUsers)
            .doc(userId)
            .collection(cUserProfile)
            .doc(dUserProfileDynamic),
        {fUserFollowersCount: FieldValue.increment(-1)});
    await batch.commit();
  }

  Future<void> addFollowInList(
    FriendProvider friend,
  ) async {
    FriendProvider old = _following.firstWhere(
        (element) => element.friendUid == friend.friendUid, orElse: () {
      return null;
    });
    if (old == null) {
      _following.insert(0, friend);
    } else {
      old.friendStatus = friend.friendStatus;
    }
    FriendProvider follower = _follower.firstWhere(
        (element) => element.friendUid == friend.friendUid, orElse: () {
      return null;
    });
    if (follower != null) follower.friendStatus = friend.friendStatus;
    followingsCount += 1;
    notifyListeners();

    _logger.i("FriendsProvider-addFollowInList");
    // Update database
    WriteBatch batch = _db.batch();
    batch.update(
        _db
            .collection(cUsers)
            .doc(_userId)
            .collection(cUserProfile)
            .doc(dUserProfileStatic),
        {fUserFollowingsCount: FieldValue.increment(1)});
    batch.update(
        _db
            .collection(cUsers)
            .doc(friend.friendUid)
            .collection(cUserProfile)
            .doc(dUserProfileDynamic),
        {fUserFollowersCount: FieldValue.increment(1)});
    await batch.commit();
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
