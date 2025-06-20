import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/widgets/login_signUp_textFields.dart';

import '../mixins/navigator_mixins.dart';

class ResetInsideApp extends StatefulWidget {
  @override
  State<ResetInsideApp> createState() => _ResetInsideAppState();
}

class _ResetInsideAppState extends State<ResetInsideApp> with NavigatorMixin {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey, // ✅ Add Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Email Field
                LoginSignupTextfields(
                  controller: _currentController,
                  icon: Icon(Icons.email),
                  labelText: AppTexts.instance.currentPass,
                  isOn: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Password Field
                LoginSignupTextfields(
                  controller: _newController,
                  icon: Icon(Icons.password),
                  labelText: AppTexts.instance.newPassword,
                  isOn: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // context.goNamed('people');
                    if (_formKey.currentState!.validate()) {
                      Authenticator().updateUserPassword(currentPassword: _currentController.text, newPassword: _newController.text);
                    }
                  },
                  child: Text(
                    AppTexts.instance.passChange,
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppTexts.instance.dntHveAccount),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).goNamed('login');
                      },
                      child: Text(AppTexts.instance.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
