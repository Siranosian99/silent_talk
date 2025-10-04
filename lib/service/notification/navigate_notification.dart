import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../global_key.dart';

void handleMessageNavigation(RemoteMessage message) {
  final context=  AppNavigator.navigatorKey.currentContext;
  if (message.data['route'] == 'settings') {
    context?.goNamed(
      'settings',
    );
  } else if (message.data['route'] == 'settings') {
    context?.goNamed(
      'settings',
    );
  }
}
