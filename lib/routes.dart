import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/chat/screens/ai_chat_screen.dart';
import 'package:silent_talk/features/chat/screens/chat_screen.dart';
import 'package:silent_talk/features/auth/screens/login_page.dart';
import 'package:silent_talk/features/user/screens/people_screen.dart';
import 'package:silent_talk/features/chat/screens/request_screen.dart';
import 'package:silent_talk/features/auth/screens/reset_email.dart';
import 'package:silent_talk/features/profile/screens/reset_password_inside.dart';
import 'package:silent_talk/features/profile/screens/settings_screen.dart';
import 'package:silent_talk/features/auth/screens/sign_up_page.dart';
import 'package:silent_talk/features/splash/screen/splash_screen.dart';
import 'package:silent_talk/features/profile/screens/update_email_screen.dart';
import 'package:silent_talk/features/profile/screens/userName_update.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';

import 'package:silent_talk/features/chat/widgets/contact_shower_sheet.dart';

import 'core/utils/biometric/auth.dart';
import 'core/utils/biometric/auth_provider.dart';
import 'core/utils/location/map_layer.dart';
import 'core/utils/location/ss.dart';
import 'core/global_key.dart';

final GoRouter router = GoRouter(
  navigatorKey: AppNavigator.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
      redirect: (context, state) async {
        final _authenticator = Authenticator();
        final _authService = AuthService();
        final boolValue = _authenticator.isLoggedOut;
        _authService.checkAvailable(context);
        final _authProvider = Provider.of<AuthenticateProvider>(
          context,
          listen: false,
        );
        bool isLocked = _authProvider.isAuth; // your app lock
        bool isAuth = await _authService.checkAuth(); // device auth available
        _authService.checkAvailable(context);
        final isLoggedIn = FirebaseAuth.instance.currentUser;
        if (!boolValue) {
          if (isLoggedIn != null) {
            // user logged in
            if (isLocked && isAuth) {
              return '/login';
            } else {
              return '/people';
            }
          } else {
            if (isLocked && isAuth) {
              return '/login';
            } else {
              return '/login';
            }
          }
        }
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
        final user = FirebaseAuth.instance.currentUser;
        final isLoggedIn = user;

        if (isLoggedIn != null && user!.emailVerified) {
          return '/people'; // user already logged in → skip login
        } else {
          print(
            ""
            "verify your emailll",
          );
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
          receiverId: extra?['receiverId'],
          // senderId: extra?['senderId'],
          // receiverId: extra?['receiverId'],
          name: extra?['name'],
        );
      },
    ),

    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final index = data['index'] as int;
        final id = data['id'] as String;
        return ContactScreen(index: index, id: id);
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
    GoRoute(
      path: '/request',
      name: 'request',
      builder: (context, state) => RequestScreen(),
    ),
    GoRoute(
      path: '/ai',
      name: 'ai',
      builder: (context, state) => AiChatScreen(),
    ),
    GoRoute(
      path: '/mapLayer',
      name: 'mapLayer',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final latitude = data['latitude'] as double;
        final longitude = data['longitude'] as double;
        final receiverId = data['receiverId'] as String;

        return MapSample(
          latitude: latitude,
          longitude: longitude,
          receiverId: receiverId,
        );
      },
    ),
    GoRoute(
      path: '/mp',
      name: 'mp',
      builder: (context, state) => AppleMapsExample(),
    ),
  ],
);
// GoRoute(
//   path: '/chatScreen',
//   name: 'chatScreen',
//   builder: (context, state) {
//     return ChatScreen();
//   },
// ),

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
