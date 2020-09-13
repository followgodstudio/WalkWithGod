import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configurations/theme.dart';
import 'providers/article/articles_provider.dart';
import 'providers/article/comments_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user/friends_provider.dart';
import 'providers/user/messages_provider.dart';
import 'providers/user/profile_provider.dart';
import 'providers/user/saved_articles_provider.dart';
import 'screens/article_screen/article_screen.dart';
import 'screens/auth_screen/email_auth_screen.dart';
import 'screens/auth_screen/login_screen.dart';
import 'screens/auth_screen/signup_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/personal_management_screen/friends/friends_list_screen.dart';
import 'screens/personal_management_screen/headline/edit_image_screen.dart';
import 'screens/personal_management_screen/headline/edit_profile_screen.dart';
import 'screens/personal_management_screen/headline/network_screen.dart';
import 'screens/personal_management_screen/messages/messages_list_screen.dart';
import 'screens/personal_management_screen/personal_management_screen.dart';
import 'screens/personal_management_screen/saved_articles/saved_articles_screen.dart';
import 'screens/personal_management_screen/setting/setting_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ArticlesProvider>(
          create: (_) => ArticlesProvider(),
          update: (context, auth, previou) =>
              ArticlesProvider(auth.currentUser),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FriendsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SavedArticlesProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (context, auth, previou) => ProfileProvider(auth.currentUser),
        ),
      ],
      child: LifeCycleManager(
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Walk With God',
            debugShowCheckedModeBanner: false,
            theme: dayTheme,
            home: StreamBuilder<String>(
                stream: auth.onAuthStateChanged,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final bool isLoggedIn = snapshot.hasData;
                    return isLoggedIn ? HomeScreen() : EmailAuthScreen();
                  }
                  return LoadingScreen();
                }),
            routes: {
              //LoginScreengi.routeName: (ctx) => LoginScreen(),
              //SignupScreen.routeName: (ctx) => SignupScreen(),
              PersonalManagementScreen.routeName: (ctx) =>
                  PersonalManagementScreen(),
              SettingScreen.routeName: (ctx) => SettingScreen(),
              MessagesListScreen.routeName: (ctx) => MessagesListScreen(),
              FriendsListScreen.routeName: (ctx) => FriendsListScreen(),
              EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
              EditPictureScreen.routeName: (ctx) => EditPictureScreen(),
              NetworkScreen.routeName: (ctx) => NetworkScreen(),
              SavedArticlesScreen.routeName: (ctx) => SavedArticlesScreen(),
              EmailAuthScreen.routeName: (ctx) => EmailAuthScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              ArticleScreen.routeName: (ctx) => ArticleScreen(),
              SignupScreen.routeName: (ctx) =>
                  SignupScreen(authFormType: AuthFormType.signUp),
            },
          ),
        ),
      ),
    );
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
          .updateReadDuration(_start);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
