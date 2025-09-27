import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/utils/biometric/auth.dart';

import '../utils/biometric/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isAuth;

  @override
  void didChangeDependencies() {
    checkingAuth();
    super.didChangeDependencies();
  }

  Future<void> checkingAuth() async {
    final _authProvider = Provider.of<AuthenticateProvider>(context);
    if (_authProvider.isAuth) {
      await AuthService().checkAvailable(context);
    } else if (_authProvider.isAuth == false) {
      context.goNamed("people");
    }
  }

  // @override
  // void dispose() {
  //   checkingAuth();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
