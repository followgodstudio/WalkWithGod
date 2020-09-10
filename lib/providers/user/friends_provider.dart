import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../configurations/constants.dart';
import 'friend_provider.dart';

class FriendsProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  List<FriendProvider> _follower = [];
  List<FriendProvider> _following = [];
  String _userId;
  String _userName;
  String _userImageUrl;
  DocumentSnapshot _lastVisibleFollower;
  DocumentSnapshot _lastVisibleFollowing;
  bool _noMoreFollower = false;
  bool _noMoreFollowing = false;
  bool _isFetching = false; // To avoid frequently request

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

  Future<void> fetchFriendListByUid(
      String userId, String userName, String userImageUrl, bool isFollower,
      [int limit = loadLimit]) async {
    if (userId == null) return;
    List<String> whereIn = [eFriendStatusFollowing, eFriendStatusFriend];
    String orderBy = fFriendFollowingDate;
    if (isFollower) {
      whereIn = [eFriendStatusFollower, eFriendStatusFriend];
      orderBy = fFriendFollowerDate;
      _follower = [];
    } else {
      _following = [];
    }
    QuerySnapshot query = await _db
        .collection(cUsers)
        .document(userId)
        .collection(cUserFriends)
        .where(fFriendStatus, whereIn: whereIn)
        .orderBy(orderBy, descending: true)
        .limit(limit)
        .getDocuments();
    _userId = userId;
    _userName = userName;
    _userImageUrl = userImageUrl;
    _appendFriendsList(query, limit, isFollower);
  }

  Future<void> fetchMoreFriends(bool isFollower,
      [int limit = loadLimit]) async {
    if (_userId == null || _isFetching) return;
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
        .document(_userId)
        .collection(cUserFriends)
        .orderBy(fCreatedDate, descending: true)
        .where(fFriendStatus, whereIn: whereIn)
        .orderBy(orderBy, descending: true)
        .startAfterDocument(lastVisible)
        .limit(limit)
        .getDocuments();
    _isFetching = false;
    _appendFriendsList(query, limit, isFollower);
  }

  Future<FriendProvider> fetchFriendStatusByUid(
      String curUserId, String userId) async {
    if (userId == null || userId.isEmpty) return null;
    DocumentSnapshot doc = await _db
        .collection(cUsers)
        .document(curUserId)
        .collection(cUserFriends)
        .document(userId)
        .get();
    if (doc.exists) return _buildFriendByMap(doc.documentID, doc.data);
    return null;
  }

  Future<void> updateUnfollowInList(String uid) async {
    _following.removeWhere((item) => item.friendUid == uid);
    FriendProvider friend =
        _follower.firstWhere((element) => element.friendUid == uid, orElse: () {
      return null;
    });
    if (friend != null) friend.friendStatus = eFriendStatusFollower;
    notifyListeners();
  }

  Future<void> addFollowInList(FriendProvider friend) async {
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
    notifyListeners();
  }

  void _appendFriendsList(QuerySnapshot query, int limit, bool isFollower) {
    List<DocumentSnapshot> docs = query.documents;
    if (isFollower) {
      docs.forEach((data) {
        _follower.add(_buildFriendByMap(data.documentID, data.data));
      });
      if (docs.length < limit) _noMoreFollower = true;
      if (docs.length > 0)
        _lastVisibleFollower = query.documents[query.documents.length - 1];
    } else {
      docs.forEach((data) {
        _following.add(_buildFriendByMap(data.documentID, data.data));
      });
      if (docs.length < limit) _noMoreFollowing = true;
      if (docs.length > 0)
        _lastVisibleFollowing = query.documents[query.documents.length - 1];
    }
    notifyListeners();
  }

  FriendProvider _buildFriendByMap(String id, Map<String, dynamic> data) {
    return FriendProvider(
      uid: _userId,
      name: _userName,
      imageUrl: _userImageUrl,
      friendUid: id,
      friendName: data[fFriendName],
      friendImageUrl: data[fFriendImageUrl],
      friendStatus: data[fFriendStatus],
    );
  }
}
