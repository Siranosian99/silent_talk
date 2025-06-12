import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/screens/chat_screen.dart';
import 'package:silent_talk/screens/login_page.dart';
import 'package:silent_talk/screens/main_screen.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/reset_password.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';
import 'package:silent_talk/widgets/contact_shower_sheet.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: '/', builder: (context, state) => MainScreen()),
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
    ),
    GoRoute(
      name: 'chat',
      path: '/chat/:id/:senderId/:receiverId',
      builder: (context, state) {
        final senderId = state.pathParameters['senderId'];
        final receiverId = state.pathParameters['receiverId'];
        final idString = state.pathParameters['id'];
        final id = int.tryParse(idString ?? '') ?? 0; // Fallback to 0 or handle error
        return ChatScreen(id:id,senderId:senderId,receiverId: receiverId, );
      },
    ),
    GoRoute(
      name: 'chatWithName',
      path: '/chat/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;

        return ChatScreen(contactId: name); // with parameter
      },
    ),



    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) => ContactScreen(),
    ),
    GoRoute(
      path: '/resetPassword',
      name: 'resetPassword',
      builder: (context, state) => ResetPasswordScreen(),
    ),
  ],
);
