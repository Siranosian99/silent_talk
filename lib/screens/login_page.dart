import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/widgets/login_signUp_textFields.dart';

import '../mixins/navigator_mixins.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with NavigatorMixin {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              Text(
                AppTexts.instance.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 40),
              LoginSignupTextfields(
                icon: Icon(Icons.email),
                labelText: AppTexts.instance.email,
                isOn: false,
              ),
              SizedBox(height: 16),
              LoginSignupTextfields(
                icon: Icon(Icons.password),
                labelText: AppTexts.instance.password,
                isOn: true,
              ),
              SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.goNamed('resetPassword');
                  },
                  child: Text(AppTexts.instance.forgetPass),
                ),
              ),

              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed('people');
                  Authenticator().login(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppTexts.instance.login,
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 30),

              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppTexts.instance.dntHveAccount),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed('signUp');
                    },
                    child: Text(AppTexts.instance.signUp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
