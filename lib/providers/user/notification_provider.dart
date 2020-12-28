import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../screens/personal_management_screen/messages/messages_list_screen.dart';
import '../../utils/my_logger.dart';

class NotificationProvider with ChangeNotifier {
  BuildContext _context;
  MyLogger _logger = MyLogger("Provider");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotification() {
    initLocalNotification();
    // initFirebaseMessaging();
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
    if (message.containsKey('data')) {
      // Handle data message
      print("onBackgroukdMessage: $message");
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("onBackgroukdMessage: $message");
    }
    print("onBackgroukdMessage: $message");
    // Or do other work.
  }

  void initFirebaseMessaging() {
    _logger.i("NotificationProvider-initFirebaseMessaging");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(
            message['notification']['title'], message['notification']['body']);
        print("onMessage: $message");
      },
      onBackgroundMessage: null,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  updateContext(BuildContext context) {
    _context = context;
  }

  Future onSelectNotification(String payload) async {
    _logger.i("NotificationProvider-onSelectNotification-$payload");
    Navigator.of(_context).pushNamed(MessagesListScreen.routeName);
  }

  showNotification(String title, String message) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, message, platform,
        payload: 'Welcome to the Local Notification demo');
  }
}
