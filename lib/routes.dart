import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/screens/chat_screen.dart';
import 'package:silent_talk/screens/login_page.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/reset_email.dart';
import 'package:silent_talk/screens/reset_password_inside.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';
import 'package:silent_talk/screens/splash_screen.dart';
import 'package:silent_talk/screens/update_email_screen.dart';
import 'package:silent_talk/screens/userName_update.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/utils/biometric/auth.dart';
import 'package:silent_talk/utils/biometric/auth_provider.dart';
import 'package:silent_talk/widgets/contact_shower_sheet.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
      redirect: (context, state) async {
        final _authProvider = Provider.of<AuthenticateProvider>(context);
        bool isLocked = _authProvider.isAuth;
        bool isAuth = await AuthService().checkAuth();
        final isLoggedIn = FirebaseAuth.instance.currentUser;
        if (isLoggedIn != null && !isAuth && !isLocked) {
          return '/people'; // send user to login instead
        } else if (isLoggedIn == null && !isAuth && !isLocked) {
          return '/login';
        } else {
          return '/';
        }
        return null; // allow access to MainScreen
      },
    ),
    // GoRoute(
    //   path: '/main',
    //   name: 'main',
    //   builder: (context, state) =>MainScreen(),
    // ),
    GoRoute(
      path: '/people',
      name: 'people',
      builder: (context, state) => PeopleScreen(),
    ),

    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: '/signUp',
      name: 'signUp',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
      redirect: (context, state) {
        final isLoggedIn = FirebaseAuth.instance.currentUser;

        if (isLoggedIn != null) {
          return '/people'; // user already logged in → skip login
        }

        return null; // stay on /login
      },
    ),

    GoRoute(
      name: 'chat',
      path: '/chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return ChatScreen(
          id: extra?['id'],
          senderId: extra?['senderId'],
          receiverId: extra?['receiverId'],
          name: extra?['name'],
        );
      },
    ),

    GoRoute(
      path: '/chatScreen',
      name: 'chatScreen',
      builder: (context, state) {
        return ChatScreen();
      },
    ),

    // GoRoute(
    //   name: 'chatWithName',
    //   path: '/chat/withName/:name',
    //   builder: (context, state) {
    //     final name = state.pathParameters['name'];
    //     return ChatScreen(contactId: name);
    //   },
    // ),

    // GoRoute(
    //   path: '/chat',
    //   name: 'chatWithoutParams',
    //   builder: (context, state) => ChatScreen(),
    // ),
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) {
        final index = state.extra as int?;
        return ContactScreen(index: index!);
      },
    ),
    GoRoute(
      path: '/resetPassword',
      name: 'resetPassword',
      builder: (context, state) => ResetEmailScreen(),
    ),
    GoRoute(
      path: '/insideApp',
      name: 'insideApp',
      builder: (context, state) => ResetInsideApp(),
    ),
    GoRoute(
      path: '/updateEmail',
      name: 'updateEmail',
      builder: (context, state) => UpdateEmailScreen(),
    ),
    GoRoute(
      path: '/updateUserName',
      name: 'updateUserName',
      builder: (context, state) => UpdateUserNameScreen(),
    ),
  ],
);
