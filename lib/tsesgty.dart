// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FirebaseMessaging.instance.requestPermission();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(MyApp());
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   // You might need to handle navigation differently in the background handler
//   // or store the data to navigate when the app comes to foreground.
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _setupFCMListeners();
//   }
//
//   void _setupFCMListeners() {
//     // Handle when the app is opened from a terminated state by tapping a notification
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         _handleNotificationTap(message);
//       }
//     });
//
//     // Handle when the app is in the background and a notification is tapped
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//   }
//
//   void _handleNotificationTap(RemoteMessage message) {
//     final String? screen = message.data['screen'];
//     if (screen != null) {
//       navigatorKey.currentState?.pushNamed(screen, arguments: message.data);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomeScreen(),
//         '/messages': (context) => MessagesScreen(),
//         // Define other routes here
//       },
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(child: Text('Welcome to the Home Screen!')),
//     );
//   }
// }
//
// class MessagesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     final String? messageId = args?['messageId'];
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Messages')),
//       body: Center(child: Text('Viewing Message ID: ${messageId ?? "N/A"}')),
//     );
//   }
// }