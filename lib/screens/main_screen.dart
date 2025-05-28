import 'package:flutter/material.dart';
import 'package:silent_talk/screens/signUp_page.dart';

import 'login_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTrue=false;
    return Scaffold(
      body: LoginScreen(),
    );
  }
}
