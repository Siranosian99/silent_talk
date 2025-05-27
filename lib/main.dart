import 'package:flutter/material.dart';
import 'package:silent_talk/screens/chat_screen.dart';
import 'package:silent_talk/screens/main_screen.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silent Talk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChatScreen(),
    );
  }
}

