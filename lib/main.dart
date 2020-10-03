import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:provider/provider.dart';

import 'configurations/theme.dart';
import 'providers/article/articles_provider.dart';
import 'providers/article/comments_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/splash_provider.dart';
import 'providers/user/friends_provider.dart';
import 'providers/user/messages_provider.dart';
import 'providers/user/profile_provider.dart';
import 'providers/user/recent_read_provider.dart';
import 'providers/user/saved_articles_provider.dart';
import 'providers/user/setting_provider.dart';
import 'screens/article_screen/article_screen.dart';
import 'screens/auth_screen/email_auth_screen.dart';
import 'screens/auth_screen/signup_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/personal_management_screen/friends/friends_list_screen.dart';
import 'screens/personal_management_screen/headline/edit_image_screen.dart';
import 'screens/personal_management_screen/headline/edit_profile_screen.dart';
import 'screens/personal_management_screen/headline/network_screen.dart';
import 'screens/personal_management_screen/messages/messages_list_screen.dart';
import 'screens/personal_management_screen/personal_management_screen.dart';
import 'screens/personal_management_screen/saved_articles/saved_articles_screen.dart';
import 'screens/personal_management_screen/setting/about_us_screen.dart';
import 'screens/personal_management_screen/setting/app_info_screen.dart';
import 'screens/personal_management_screen/setting/black_list_screen.dart';
import 'screens/personal_management_screen/setting/cache_clear_screen.dart';
import 'screens/personal_management_screen/setting/delete_account_screen.dart';
import 'screens/personal_management_screen/setting/notification_screen.dart';
import 'screens/personal_management_screen/setting/privacy_screen.dart';
import 'screens/personal_management_screen/setting/setting_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/my_logger.dart';
import 'widgets/popup_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("MyApp");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ArticlesProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CommentsProvider(),
          ),
          ChangeNotifierProvider<SplashProvider>(
            create: (_) => SplashProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
              create: (_) => ProfileProvider(),
              update: (context, auth, _) => ProfileProvider(auth.currentUser)),
        ],
        child: Builder(builder: (BuildContext context) {
          ProfileProvider profile =
              Provider.of<ProfileProvider>(context, listen: false);
          return MultiProvider(
            providers: [
              ChangeNotifierProxyProvider<ProfileProvider,
                      SavedArticlesProvider>(
                  create: (_) => profile.savedArticlesProvider,
                  update: (context, newProfile, _) =>
                      newProfile.savedArticlesProvider),
              ChangeNotifierProxyProvider<ProfileProvider, FriendsProvider>(
                  create: (_) => profile.friendsProvider,
                  update: (context, newProfile, _) =>
                      newProfile.friendsProvider),
              ChangeNotifierProxyProvider<ProfileProvider, SettingProvider>(
                  create: (_) => profile.settingProvider,
                  update: (context, newProfile, _) =>
                      newProfile.settingProvider),
              ChangeNotifierProxyProvider<ProfileProvider, MessagesProvider>(
                  create: (_) => profile.messagesProvider,
                  update: (context, newProfile, _) =>
                      newProfile.messagesProvider),
              ChangeNotifierProxyProvider<ProfileProvider, RecentReadProvider>(
                  create: (_) => profile.recentReadProvider,
                  update: (context, newProfile, _) =>
                      newProfile.recentReadProvider),
            ],
            child: LifeCycleManager(
              child: MaterialApp(
                title: 'Walk With God',
                debugShowCheckedModeBanner: false,
                theme: dayTheme,
                home: NetworkManager(child: SplashScreen()),
                routes: {
                  PersonalManagementScreen.routeName: (ctx) =>
                      NetworkManager(child: PersonalManagementScreen()),
                  SettingScreen.routeName: (ctx) => SettingScreen(),
                  PrivacyScreen.routeName: (ctx) => PrivacyScreen(),
                  NotificationScreen.routeName: (ctx) => NotificationScreen(),
                  CacheClearScreen.routeName: (ctx) => CacheClearScreen(),
                  AppInfoScreen.routeName: (ctx) => AppInfoScreen(),
                  AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
                  BlackListScreen.routeName: (ctx) => BlackListScreen(),
                  DeleteAccountScreen.routeName: (ctx) => DeleteAccountScreen(),
                  MessagesListScreen.routeName: (ctx) => MessagesListScreen(),
                  FriendsListScreen.routeName: (ctx) => FriendsListScreen(),
                  EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
                  EditPictureScreen.routeName: (ctx) => EditPictureScreen(),
                  NetworkScreen.routeName: (ctx) =>
                      NetworkManager(child: NetworkScreen()),
                  SavedArticlesScreen.routeName: (ctx) => SavedArticlesScreen(),
                  EmailAuthScreen.routeName: (ctx) => EmailAuthScreen(),
                  HomeScreen.routeName: (ctx) =>
                      NetworkManager(child: HomeScreen()),
                  ArticleScreen.routeName: (ctx) =>
                      NetworkManager(child: ArticleScreen()),
                  SignupScreen.routeName: (ctx) => NetworkManager(
                      child: SignupScreen(authFormType: AuthFormType.signIn)),
                },
              ),
            ),
          );
        }));
  }
}

// To monitor how many time a user are using this app
class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  DateTime _start;
  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _start = DateTime.now();
    if (state == AppLifecycleState.paused)
      Provider.of<ProfileProvider>(context, listen: false)
          .recentReadProvider
          .updateReadDuration(_start);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// To monitor whether network is available
class NetworkManager extends StatefulWidget {
  final Widget child;
  NetworkManager({Key key, this.child}) : super(key: key);
  _NetworkManagerState createState() => _NetworkManagerState();
}

class _NetworkManagerState extends State<NetworkManager> {
  StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> checkNetwork() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (context) {
              return PopUpDialog(false, "请检查网络连接");
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LogConsoleOnShake(child: widget.child);
  }
}
