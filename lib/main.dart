import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configurations/theme.dart';
import 'providers/article/articles_provider.dart';
import 'providers/article/comments_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user/messages_provider.dart';
import 'providers/user/profile_provider.dart';
import 'screens/article_screen/article_screen.dart';
import 'screens/article_screen/comment_detail_screen.dart';
import 'screens/auth_screen/email_auth_screen.dart';
import 'screens/auth_screen/login_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/main_screen.dart';
import 'screens/personal_management_screen/messages/messages_list_screen.dart';
import 'screens/personal_management_screen/personal_management_screen.dart';

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
        ChangeNotifierProvider(
          create: (_) => ArticlesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessagesProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (context, auth, previou) => ProfileProvider(auth.currentUser),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Walk With God',
          debugShowCheckedModeBanner: false,
          theme: dayTheme,
          home: StreamBuilder<String>(
              stream: auth.onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
            MessagesListScreen.routeName: (ctx) => MessagesListScreen(),
            EmailAuthScreen.routeName: (ctx) => EmailAuthScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            ArticleScreen.routeName: (ctx) => ArticleScreen(),
            CommentDetailScreen.routeName: (ctx) => CommentDetailScreen(),
          },
        ),
      ),
    );
  }
}
