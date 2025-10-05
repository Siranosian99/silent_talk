import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// STEP 1: Create a global plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// STEP 2: Main entry
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Combine platform settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  /// Initialize plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        _handleNotificationTap(response.payload!);
      }
    },
  );

  /// STEP 3: Check if app was opened from a terminated state
  final details =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String initialRoute = '/';
  if (details?.didNotificationLaunchApp ?? false) {
    final payload = details?.notificationResponse?.payload;
    if (payload != null) {
      initialRoute = '/detail?data=$payload';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

/// STEP 4: Handle navigation outside BuildContext
void _handleNotificationTap(String payload) {
  // Payload contains data like "taskId=42" or "data=hello"
  MyApp.navigatorKey.currentState?.pushNamed('/detail', arguments: payload);
}

/// STEP 5: Main app widget
class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Navigation Demo',
      navigatorKey: navigatorKey,
      initialRoute: initialRoute == '/' ? '/' : '/detail',
      routes: {
        '/': (context) => HomeScreen(),
        '/detail': (context) => DetailScreen(),
      },
    );
  }
}

/// STEP 6: Home screen that triggers a notification
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      channelDescription: 'Channel for navigation test',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // The payload can be any string — route, ID, JSON, etc.
    await flutterLocalNotificationsPlugin.show(
      0,
      'Task Reminder',
      'Tap to open your Task Details',
      notificationDetails,
      payload: 'taskId=1234&title=Buy milk',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏠 Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: showNotification,
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}

/// STEP 7: Detail screen that reads payload data
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = ModalRoute.of(context)?.settings.arguments as String?;

    // Parse data if needed
    final Map<String, String> parsedData = {};
    if (payload != null && payload.contains('=')) {
      final parts = payload.split('&');
      for (var p in parts) {
        final keyValue = p.split('=');
        if (keyValue.length == 2) {
          parsedData[keyValue[0]] = keyValue[1];
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('📋 Task Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Navigated here from notification! 🎉',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            if (parsedData.isNotEmpty)
              Column(
                children: [
                  Text('Task ID: ${parsedData['taskId'] ?? 'N/A'}'),
                  Text('Title: ${parsedData['title'] ?? 'N/A'}'),
                ],
              )
            else
              Text('Payload: $payload'),
          ],
        ),
      ),
    );
  }
}
