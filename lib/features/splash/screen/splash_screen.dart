import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isAuth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
