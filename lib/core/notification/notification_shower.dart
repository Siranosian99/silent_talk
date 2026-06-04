import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';


import '../global_key.dart';
import 'get_token.dart';
import 'navigate_notification.dart';
import 'notification_helper.dart';

class NotificationHandler {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Request notification permissions (required for iOS)
    await FirebaseMessaging.instance.requestPermission();
    GetToken.getToken();
    // Initialize Local Notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          final senderId = data['senderId'];

          // Get context from navigator key
          final context = AppNavigator.navigatorKey.currentContext;
          if (context != null) {
            GoRouter.of(context).pushNamed(
              'chat',
              extra: {
                'receiverId': senderId,
              },
            );
          }
        }
      },
    );


    // Handle Notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Notification: ${message.notification?.title}");
      // final context = AppNavigator.navigatorKey.currentContext;
      // GoRouter.of(context!).pushNamed(
      //   'settings',
      // );
      _showNotification(message);
    });

    // Handle Notification when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // if (message.data.isNotEmpty) {
      //   String screen = message.data['screen'];
      //   AppNavigator.navigatorKey.currentState?.pushNamed(screen);
      // }
      // handleMessage(message);
      print("App opened by Notification: ${message.notification?.title}");
      // Handle navigation or action
    });

    // Handle Notification when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App started by Notification: ${message.notification?.title}");
        // Handle navigation or action
      }
    });

    // Handle background notifications (app running in the background)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Create Notification Channel for Android (Required for Android 8.0 and above)
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // Unique ID for the channel
      'channel_name', // Name of the channel
      importance: Importance.high, // Importance level
      enableLights: true,
      enableVibration: true,
    );
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Background message handler (app terminated or in the background)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Background Notification: ${message.notification?.title}");
    _showNotification(message);
    // _sendAutomaticNotification(message);
  }

  // Show notification on the device
  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
    // String receiverId = message.data['receiverId'];

    final data = message.data;

    final route = data['route'];
    final senderId = data['senderId'];
    final title = data['title'] ?? 'No title';
    final body = data['body'] ?? 'No body';
    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload:jsonEncode({
        'route': route,
        'senderId': senderId,
      }));
  }
  //   final String? name;
//   final int? id;
//   final String? senderId;
//   final String? receiverId;




  // Send automatic notification (for example, forwarding or auto-reply message)
  // static Future<void> _sendAutomaticNotification(RemoteMessage message) async {
  //   // Ensure the FCM token is available
  //   String? token = GetToken.token;
  //   if (token != null) {
  //     try {
  //       await NotificationService.sendNotification(
  //         token,
  //         message.notification?.title ?? "Forwarded Message",
  //         message.notification?.body ?? "You have a new forwarded notification!",
  //       );
  //     } catch (error) {
  //       print("Error sending notification: $error");
  //     }
  //   } else {
  //     print("FCM Token is not available.");
  //   }
  // }
}
