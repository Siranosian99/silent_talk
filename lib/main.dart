import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:silent_talk/routes.dart';
import 'package:silent_talk/screens/chat_screen.dart';
import 'package:silent_talk/screens/login_page.dart';
import 'package:silent_talk/screens/main_screen.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';
import 'package:silent_talk/themes/app_themes.dart';
import 'package:silent_talk/utils/themes/light_dark_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAwMCb9JOyl-8RCA6iPxnGlVw89AajFilc",
          appId: "1:156704193316:android:12088ea8a9934d143211b1",
          messagingSenderId: "156704193316",
          projectId: "silenttalk-53850")
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Silent Talk',
      theme: AppTheme.darkTheme,
    );
  }
}

// Widget build(BuildContext context) {
//   return MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Silent Talk',
//     theme: AppThemeData.lightTheme,
//     home: MainScreen(),
//   );
// }