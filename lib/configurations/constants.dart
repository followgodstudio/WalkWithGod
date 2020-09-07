///******** keys in Firestore ********///

const int loadLimit = 10;

// Global field names

const String fCreatedDate = "created_date";
const String fUpdatedDate = "updated_date";

// First Level collection names

const String cArticles = "articles";
const String cUsers = "users";

// Second level collection names

const String cArticleComments = "comments";

const String cUserReadHistory = "read_history";
const String cUserFriends = "friends";
const String cUserMessages = "messages";
const String cUserSavedarticles = "saved_articles";

// Third level collection names

const String cArticleCommentReplies = "replies";
const String cArticleCommentLikes = "likes";

// Third level field names

const String fUserName = "name";
const String fUserImageUrl = "image_url";
const String fUserMessagesCount = "messages_count";
const String fUserUnreadMsgCount = "unread_msg_count";
const String fUserFollowingsCount = "followings_count";
const String fUserFollowersCount = "followers_count";
const String fUserReadsCount = "reads_count";
const String fUserReadDuration = "read_duration";

const String fMessageType = "type";
const String eMessageTypeLike = "like";
const String eMessageTypeReply = "reply";
const String fMessageSenderUid = "sender_uid";
const String fMessageSenderName = "sender_name";
const String fMessageSenderImage = "sender_image";
const String fMessageReceiverUid = "receiver_uid";
const String fMessageArticleId = "article_id";
const String fMessageCommentId = "comment_id";
const String fMessageContent = "content";
const String fMessageIsRead = "is_read";

const String fFriendStatus = "status";
const String eFriendStatusFollowing = "following";
const String eFriendStatusFollower = "follower";
const String eFriendStatusFriend = "friend";
const String fFriendName = "name";
const String fFriendImageUrl = "image_url";
const String fFriendFollowingDate = "following_date";
const String fFriendFollowerDate = "follower_date";

const String fArticleTitle = 'title';
const String fArticleDescription = 'description';
const String fArticleImageUrl = 'image_url';
const String fArticleAuthorName = 'author_name';
const String cArticleContent = 'content';
const String fArticleIcon = 'icon';
const String fArticlePublisher = 'publisher';

const String fContentSubtitle = 'subtitle';
const String fContentBody = 'body';
const String fContentIndex = 'index';

const String fCommentArticleId = 'aid';
const String fCommentContent = 'content';
const String fCommentCreatorUid = 'creator_uid';
const String fCommentCreatorName = 'creator_name';
const String fCommentCreatorImage = 'creator_image';
const String fCommentParent = 'parent';
const String fCommentReplyToUid = 'reply_to_uid';
const String fCommentReplyToName = 'reply_to_name';
const String fCommentChildrenCount = 'children_count';
const String fCommentLikesCount = 'likes_count';
const String fCommentReplyLikes = 'likes';