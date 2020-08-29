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

const String fUserMessageType = "type";
const String eUserMessageTypeLike = "like";
const String eUserMessageTypecomment = "comment";

const String fUserMessageUid = "uid";
const String fUserMessageAid = "aid";
const String fUserMessageBody = "body";

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
