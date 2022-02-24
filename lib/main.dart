import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'configurations/app_config.dart';
import 'configurations/theme.dart';
import 'environment.dart';
import 'providers/article/articles_provider.dart';
import 'providers/article/comments_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/splash_provider.dart';
import 'providers/user/friends_provider.dart';
import 'providers/user/messages_provider.dart';
import 'providers/user/notification_provider.dart';
import 'providers/user/profile_provider.dart';
import 'providers/user/recent_read_provider.dart';
import 'providers/user/saved_articles_provider.dart';
import 'providers/user/setting_provider.dart';
import 'screens/article_screen/article_screen.dart';
import 'screens/auth_screen/phone_verification_screen.dart';
import 'screens/auth_screen/signup_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/home_screen/search_screen.dart';
import 'screens/personal_management_screen/friends/friends_list_screen.dart';
import 'screens/personal_management_screen/headline/network_screen.dart';
import 'screens/personal_management_screen/messages/messages_list_screen.dart';
import 'screens/personal_management_screen/personal_management_screen.dart';
import 'screens/personal_management_screen/saved_articles/saved_articles_screen.dart';
import 'screens/personal_management_screen/recent_read/recent_read_screen.dart';
import 'screens/personal_management_screen/setting/about_us_screen.dart';
import 'screens/personal_management_screen/setting/app_info_screen.dart';
import 'screens/personal_management_screen/setting/black_list_screen.dart';
import 'screens/personal_management_screen/setting/cache_clear_screen.dart';
import 'screens/personal_management_screen/setting/delete_account_screen.dart';
import 'screens/personal_management_screen/setting/edit_image_screen.dart';
import 'screens/personal_management_screen/setting/edit_profile_screen.dart';
import 'screens/personal_management_screen/setting/feedback_screen.dart';
import 'screens/personal_management_screen/setting/notification_screen.dart';
import 'screens/personal_management_screen/setting/privacy_screen.dart';
import 'screens/personal_management_screen/setting/setting_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/network_manager.dart';

class MyApp extends StatelessWidget {
  final Environment environment;

  const MyApp({Key key, @required this.environment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarIconBrightness: Brightness.dark));
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
          ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
              create: (_) => ProfileProvider(),
              update: (context, auth, _) => ProfileProvider(auth.userId)),
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
                title: AppConfig.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                theme: dayTheme,
                home: NetworkManager(child: SplashScreen()),
                routes: {
                  SplashScreen.routeName: (ctx) =>
                      NetworkManager(child: SplashScreen()),
                  PersonalManagementScreen.routeName: (ctx) =>
                      NetworkManager(child: PersonalManagementScreen()),
                  SettingScreen.routeName: (ctx) => SettingScreen(),
                  PrivacyScreen.routeName: (ctx) => PrivacyScreen(),
                  FeedbackScreen.routeName: (ctx) => FeedbackScreen(),
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
                  RecentReadScreen.routeName: (ctx) => RecentReadScreen(),
                  HomeScreen.routeName: (ctx) =>
                      NetworkManager(child: HomeScreen()),
                  SearchScreen.routeName: (ctx) =>
                      NetworkManager(child: SearchScreen()),
                  ArticleScreen.routeName: (ctx) =>
                      NetworkManager(child: ArticleScreen()),
                  SignupScreen.routeName: (ctx) => NetworkManager(
                      child: SignupScreen(authFormType: AuthFormType.signIn)),
                  PhoneVerificationScreen.routeName: (ctx) =>
                      NetworkManager(child: PhoneVerificationScreen()),
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
