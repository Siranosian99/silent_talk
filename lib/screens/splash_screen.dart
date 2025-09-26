import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/utils/biometric/auth.dart';

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
  Future<void> checkingAuth()async{

    isAuth=await AuthService().checkAuth();
    print(isAuth);
    if(isAuth !=null && isAuth== true){
      await AuthService().checkAvailable(context, isAuth!);
    }
    else if(isAuth !=null && isAuth== false){
     context.goNamed("login");
    }
  }
  // @override
  // void dispose() {
  //   checkingAuth();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
