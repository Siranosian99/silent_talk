import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';


import '../../global_key.dart';
import 'get_token.dart';
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
        print("Notification Clicked: ${response.payload}");
        // Handle navigation or action after clicking the notification
      },
    );

    // Handle Notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final context = AppNavigator.navigatorKey.currentContext;
      GoRouter.of(context!).pushNamed(
        'chat',
        extra: {
          'id': "Bq7CWRqltmVv2DaKCBk6aKotttk2_u5SViY9x0UdEXED6mU19AM7IODA3",
        },
      );
      print("Foreground Notification: ${message.notification?.title}");
      _showNotification(message);
    });

    // Handle Notification when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
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
    _sendAutomaticNotification(message);
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

    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  // Send automatic notification (for example, forwarding or auto-reply message)
  static Future<void> _sendAutomaticNotification(RemoteMessage message) async {
    // Ensure the FCM token is available
    String? token = GetToken.token;
    if (token != null) {
      try {
        await NotificationService.sendNotification(
          token,
          message.notification?.title ?? "Forwarded Message",
          message.notification?.body ?? "You have a new forwarded notification!",
        );
      } catch (error) {
        print("Error sending notification: $error");
      }
    } else {
      print("FCM Token is not available.");
    }
  }
}
