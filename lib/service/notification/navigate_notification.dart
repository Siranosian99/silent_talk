import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../global_key.dart';
import '../../screens/chat_screen.dart';

// void handleMessageNavigation(RemoteMessage message) {
//   final context=  AppNavigator.navigatorKey.currentContext;
//   if (message.data['route'] == 'settings') {
//     context?.goNamed(
//       'settings',
//     );
//   } else if (message.data['route'] == 'people') {
//     context?.goNamed(
//       'people',
//     );
//   }
// void handleMessage(RemoteMessage message) {
//   String chatId = message.data['chatId']; // Make sure server sends chatId
//   String senderId = message.data['senderId'];
//   String recieverId=message.data['receiverId'];
//   final context=AppNavigator.navigatorKey.currentContext!;
//
//   // Navigate to ChatScreen with chatId
//   GoRouter.of(context).pushNamed(
//     'chat',
//     extra: {
//       'index':0,
//       'senderId': senderId,
//       'receiverId': recieverId,
//     },
//   );
// }
//
//   void onNotificationTap(NotificationResponse response) {
//     final payload = response.payload;
//
//     if (payload != null && payload.isNotEmpty) {
//       // For example payload: {"chatId": "u123", "userName": "John"}
//       final Map<String, dynamic> data = jsonDecode(payload);
//
//       AppNavigator.navigatorKey.currentState?.pushNamed(
//         '/chat',
//         arguments: data,
//       );
//     }
//
// }

// final FlutterLocalNotificationsPlugin _localNotifications =
//     FlutterLocalNotificationsPlugin();
// Future<void> showNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//
//   const NotificationDetails notificationDetails = NotificationDetails(
//     android: androidDetails,
//   );
//   final payload = jsonEncode({
//     'id': 1,
//     'senderId': 'Pttpb7DGYcOYACI1hWkB6oTVTRl1',
//     'receiverId': 'DbPNIqQM1eQxi378PHzOxJh9D5o2',
//   });
//   await _localNotifications.show(
//     0,
//     message.notification?.title,
//     message.notification?.body,
//     notificationDetails,
//     payload: payload,
//   );
// }
