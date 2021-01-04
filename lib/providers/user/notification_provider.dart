import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../screens/article_screen/article_screen.dart';
import '../../screens/personal_management_screen/messages/messages_list_screen.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import 'messages_provider.dart';

class NotificationProvider with ChangeNotifier {
  BuildContext _context;
  MyLogger _logger = MyLogger("Provider");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotification() {
    initLocalNotification();
    initFirebaseMessaging();
  }

  void initLocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_logo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    showPopupNotification(
        message['notification']['title'], message['notification']['body']);
  }

  void initFirebaseMessaging() {
    _logger.i("NotificationProvider-initFirebaseMessaging");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _logger.i("NotificationProvider-onMessage-$message");
        showPopUpDialog(
          _context,
          true,
          message['notification']['title'],
          durationMilliseconds: 3000,
          onPressed: () {
            navigateToDetail(message);
          },
        );
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _logger.i("NotificationProvider-onLaunch-$message");
        navigateToDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _logger.i("NotificationProvider-onResume-$message");
        navigateToDetail(message);
      },
    );
  }

  void navigateToDetail(Map<String, dynamic> message) {
    String articleId = message['data']['article_id'];
    String messageId = message['data']['message_id'];
    String commentId = message['data']['comment_id'];
    String userId = message['data']['user_id'];
    MessagesProvider.markMessageAsRead(userId, messageId);
    Navigator.of(_context).pushNamed(
      ArticleScreen.routeName,
      arguments: {"articleId": articleId, "commentId": commentId},
    );
  }

  updateContext(BuildContext context) {
    _context = context;
  }

  Future onSelectNotification(String payload) async {
    _logger.i("NotificationProvider-onSelectNotification-$payload");
    Navigator.of(_context).pushNamed(MessagesListScreen.routeName);
  }

  static showPopupNotification(String title, String message) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await FlutterLocalNotificationsPlugin().show(0, title, message, platform,
        payload: 'Welcome to the Local Notification demo');
  }

  showInAppNotification(String title, String message) async {
    showPopUpDialog(_context, true, title);
  }
}
