///******** keys in Firestore ********///

// Global field names

const String F_CREATE_DATE = "createdAt";
const String F_UPDATE_DATE = "updatedAt";

// First Level collection names

const String C_ARTICLES = "articles";
const String C_USERS = "users";

// Second level collection names

const String C_USER_PROFILE = "profile";
const String C_USER_FOLLOWERS = "followers";
const String C_USER_FOLLOWINGS = "followings";
const String C_USER_MESSAGES = "messages";
const String C_USER_SAVEDARTICLES = "savedArticles";

// Third level field names

const String F_USER_PROFILE_NAME = "name";
const String F_USER_PROFILE_IMAGEURL = "imageUrl";

const String F_USER_MESSAGE_TYPE = "type";
const E_USER_MESSAGE_TYPE_LIKE = "like";
const E_USER_MESSAGE_TYPE_COMMENT = "comment";

const String F_USER_MESSAGE_UID = "uid";
const String F_USER_MESSAGE_AID = "aid";
const String F_USER_MESSAGE_BODY = "body";
