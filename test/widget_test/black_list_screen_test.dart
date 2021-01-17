import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/main.dart';
import 'package:walk_with_god/providers/article/articles_provider.dart';
import 'package:walk_with_god/providers/article/comments_provider.dart';
import 'package:walk_with_god/providers/auth_provider.dart';
import 'package:walk_with_god/providers/splash_provider.dart';
import 'package:walk_with_god/providers/user/friends_provider.dart';
import 'package:walk_with_god/providers/user/messages_provider.dart';
import 'package:walk_with_god/providers/user/notification_provider.dart';
import 'package:walk_with_god/providers/user/profile_provider.dart';
import 'package:walk_with_god/providers/user/recent_read_provider.dart';
import 'package:walk_with_god/providers/user/saved_articles_provider.dart';
import 'package:walk_with_god/providers/user/setting_provider.dart';

import 'package:walk_with_god/screens/personal_management_screen/personal_management_screen.dart';
import 'package:walk_with_god/screens/personal_management_screen/setting/black_list_screen.dart';

void main() async {
  testWidgets('Test Black List', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(title: 'Follow Him', home: BlackListScreen()));
    final messageFinder = find.text('黑名单');
    expect(messageFinder, findsOneWidget);
    // await tester.pumpWidget(MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(
    //         create: (_) => AuthProvider(),
    //       ),
    //       ChangeNotifierProvider(
    //         create: (_) => ArticlesProvider(),
    //       ),
    //       ChangeNotifierProvider(
    //         create: (_) => CommentsProvider(),
    //       ),
    //       ChangeNotifierProvider<SplashProvider>(
    //         create: (_) => SplashProvider(),
    //       ),
    //       ChangeNotifierProvider<NotificationProvider>(
    //         create: (_) => NotificationProvider(),
    //       ),
    //       ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
    //           create: (_) => ProfileProvider(),
    //           update: (context, auth, _) => ProfileProvider(auth.userId)),
    //     ],
    //     child: Builder(
    //       builder: (BuildContext context) {
    //         ProfileProvider profile =
    //             Provider.of<ProfileProvider>(context, listen: false);
    //         return MultiProvider(
    //             providers: [
    //               ChangeNotifierProxyProvider<ProfileProvider,
    //                       SavedArticlesProvider>(
    //                   create: (_) => profile.savedArticlesProvider,
    //                   update: (context, newProfile, _) =>
    //                       newProfile.savedArticlesProvider),
    //               ChangeNotifierProxyProvider<ProfileProvider, FriendsProvider>(
    //                   create: (_) => profile.friendsProvider,
    //                   update: (context, newProfile, _) =>
    //                       newProfile.friendsProvider),
    //               ChangeNotifierProxyProvider<ProfileProvider, SettingProvider>(
    //                   create: (_) => profile.settingProvider,
    //                   update: (context, newProfile, _) =>
    //                       newProfile.settingProvider),
    //               ChangeNotifierProxyProvider<ProfileProvider,
    //                       MessagesProvider>(
    //                   create: (_) => profile.messagesProvider,
    //                   update: (context, newProfile, _) =>
    //                       newProfile.messagesProvider),
    //               ChangeNotifierProxyProvider<ProfileProvider,
    //                       RecentReadProvider>(
    //                   create: (_) => profile.recentReadProvider,
    //                   update: (context, newProfile, _) =>
    //                       newProfile.recentReadProvider),
    //             ],
    //             child: MaterialApp(
    //                 title: 'Follow Him', home: PersonalManagementScreen()));
    //       },
    //     )));

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
