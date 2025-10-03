// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
//
// void navigateWithNotifications(int ibde) {
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     final data = message.data;
//     final context = AppNavigator.navigatorKey.currentContext;
//     if (context != null) {
//       GoRouter.of(context).pushNamed(
//           'chat',
//           extra: {
//             'id': index,
//             'senderId': Authenticator().user?.uid,
//             'receiverId': user.id,
//           },
//           }
//           print("App opened by Notification: ${message.notification?.title}");
//       // Handle navigation or action
//     });
// }