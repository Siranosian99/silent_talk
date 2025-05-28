import 'package:flutter/material.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/widgets/login_signUp_textFields.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
              LoginSignupTextfields(icon: Icon(Icons.email), labelText: AppTexts.instance.email,isOn: false,),
              SizedBox(height: 16),
              LoginSignupTextfields(icon: Icon(Icons.password), labelText: AppTexts.instance.password,isOn: true,),
              SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to Forgot Password Screen
                  },
                  child: Text(AppTexts.instance.forgetPass),
                ),
              ),

              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Handle login
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
                      // Navigate to Sign Up Screen
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
