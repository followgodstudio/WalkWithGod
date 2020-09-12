import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/screens/auth_screen/signup_screen.dart';

import 'configurations/theme.dart';
import 'providers/article/articles_provider.dart';
import 'providers/article/comments_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user/friends_provider.dart';
import 'providers/user/messages_provider.dart';
import 'providers/user/profile_provider.dart';
import 'providers/user/saved_articles_provider.dart';
import 'screens/article_screen/article_screen.dart';
import 'screens/article_screen/comment_detail_screen.dart';
import 'screens/auth_screen/email_auth_screen.dart';
import 'screens/auth_screen/login_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/main_screen.dart';
import 'screens/personal_management_screen/friends/friends_list_screen.dart';
import 'screens/personal_management_screen/headline/edit_profile_screen.dart';
import 'screens/personal_management_screen/headline/network_screen.dart';
import 'screens/personal_management_screen/messages/messages_list_screen.dart';
import 'screens/personal_management_screen/personal_management_screen.dart';
import 'screens/personal_management_screen/setting/setting_screen.dart';

void main() => runApp(MyApp());

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Walk With God',
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          theme: dayTheme,
          home: StreamBuilder<String>(
              stream: auth.onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final bool isLoggedIn = snapshot.hasData;
                  return isLoggedIn
                      ? HomeScreen()
                      //: EmailAuthScreen();
                      : SignupScreen(authFormType: AuthFormType.signUp);
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
            NetworkScreen.routeName: (ctx) => NetworkScreen(),
            EmailAuthScreen.routeName: (ctx) => EmailAuthScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            ArticleScreen.routeName: (ctx) => RouteAwareWidget(ArticleScreen()),
            CommentDetailScreen.routeName: (ctx) => CommentDetailScreen(),
            SignupScreen.routeName: (ctx) =>
                SignupScreen(authFormType: AuthFormType.signUp),
          },
        ),
      ),
    );
  }
}

// This widget is to observe the duration of reading articles
class RouteAwareWidget extends StatefulWidget {
  final Widget child;
  RouteAwareWidget(this.child);

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

// Implement RouteAware in a widget's state and subscribe it to the RouteObserver.
class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  String _articleId;
  ProfileProvider _profile;
  DateTime _start;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
    print('didChangeDependencies');
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    print('dispose');
    super.dispose();
  }

  @override
  // Called when the current route has been pushed.
  void didPush() {
    print('didPush');
    // Should start calculating time
    _start = DateTime.now();
  }

  @override
  // Called when a new route has been pushed, and the current route is no longer visible.
  void didPushNext() {
    print('didPushNext');
    // Should stop calculating time
    _profile.updateReadByAid(_articleId, _start, DateTime.now());
  }

  @override
  // Called when the current route has been popped off.
  void didPop() {
    print('didPop');
    // Should stop calculating time
    _profile.updateReadByAid(_articleId, _start, DateTime.now());
  }

  @override
  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {
    print('didPopNext');
    // Should resume calculating time
    _start = DateTime.now();
  }

  //TODO: Stop counting duration when the app is switched to background
  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileProvider>(context, listen: false);
    _articleId = ModalRoute.of(context).settings.arguments as String;
    return widget.child;
  }
}
