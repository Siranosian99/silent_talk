import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../global_key.dart';

void handleMessageNavigation(RemoteMessage message) {
  final context=  AppNavigator.navigatorKey.currentContext;
  if (message.data['route'] == 'settings') {
    context?.goNamed(
      'settings',
    );
  } else if (message.data['route'] == 'people') {
    context?.goNamed(
      'people',
    );
  }
  void onNotificationTap(NotificationResponse response) {
    final payload = response.payload;

    if (payload != null && payload.isNotEmpty) {
      // For example payload: {"chatId": "u123", "userName": "John"}
      final Map<String, dynamic> data = jsonDecode(payload);

      AppNavigator.navigatorKey.currentState?.pushNamed(
        '/chat',
        arguments: data,
      );
    }
  }

}
