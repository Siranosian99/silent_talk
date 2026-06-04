import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/servicecontrol/v2.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/auth/widgets/login_signUp_textFields.dart';

import '../../../core/mixins/navigator_mixins.dart';
import '../../../core/widgets/language_dropDown.dart';
import '../../../l10n/app_localizations.dart';

import '../services/get_deviceId.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with NavigatorMixin {
  final Authenticator _authenticator=Authenticator();
  late final bool boolValue;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // @override
  //   void initState() {
  //   requestPermission();
  //     super.initState();
  //   }
  //   Future<void>requestPermission ()async{
  //     await FileSaver.checkAndRequestStoragePermission();
  //   }



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
                // App Title
                Text(
                  AppLocalizations.of(context)!.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 40),
                // Email Field
                LoginSignupTextfields(
                  controller: _emailController,
                  icon: Icon(Icons.email),
                  labelText: AppLocalizations.of(context)!.email,
                  isOn: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Password Field
                LoginSignupTextfields(
                  controller: _passwordController,
                  icon: Icon(Icons.password),
                  labelText: AppLocalizations.of(context)!.password,
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.goNamed('resetPassword');
                    },
                    child: Text(AppLocalizations.of(context)!.passChange),
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    // context.goNamed('people');
                    if (_formKey.currentState!.validate()) {
                      Authenticator().login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        context,
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dntHveAccount),
                    TextButton(
                      onPressed: () {
                        context.goNamed('signUp');
                      },
                      child: Text(AppLocalizations.of(context)!.signUp),
                    ),
                  ],
                ),
                LanguageDropdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
