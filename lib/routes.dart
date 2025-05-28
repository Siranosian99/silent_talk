import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/screens/login_page.dart';
import 'package:silent_talk/screens/main_screen.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/people',
      name: 'people',
      builder: (context, state) => PeopleScreen(),
    ),
    GoRoute(path: '/settigs',builder: (context, state) => SettingsScreen()),
    GoRoute(path: '/signUp',name: 'signUp',builder: (context, state) => SignUpScreen()),
    GoRoute(path: '/login',name: 'login',builder: (context, state) => LoginScreen())
  ],
);
