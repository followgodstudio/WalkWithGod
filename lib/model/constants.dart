///******** keys in Firestore ********///

// Global field names

const String fCreateDate = "createdAt";
const String fUpdateDate = "updatedAt";

// First Level collection names

const String cArticles = "articles";
const String cUsers = "users";
const String cComments = "comments";
const String cMessages = "messages";

// Second level collection names

const String cUserProfile = "profile";
const String cUserfollowers = "followers";
const String cUserfollowings = "followings";
const String cUserMessages = "messages";
const String cUserSavedarticles = "savedArticles";

// Third level field names

const String fUserProfileName = "name";
const String fUserProfileImageUrl = "imageUrl";

const String fMessageType = "type";
const String eMessageTypeLike = "like";
const String eMessageTypeReply = "reply";
const String fMessageCreator = "creator";
const String fMessageReceiver = "receiver";
const String fMessageArticleId = "articleId";
const String fMessageContent = "content";
const String fMessageIsRead = "isRead";

const String fArticleTitle = 'title';
const String fArticleDescription = 'description';
const String fArticleImageurl = 'imageUrl';
const String fArticleAuthor = 'author';
const String fArticleContent = 'content';
const String fArticleIcon = 'icon';

const String fCommentArticleId = 'articleId';
const String fCommentContent = 'content';
const String fCommentCreator = 'creator';
const String fCommentParent = 'parent';
const String fCommentReplyTo = 'replyTo';
const String fCommentChildren = 'children';
const String fCommentLike = 'like';
