import 'package:flutter/material.dart';
import 'package:silent_talk/constants/texts.dart';

import '../service/authenticator/authenticator.dart';

class ResetEmailScreen extends StatefulWidget {
  const ResetEmailScreen({Key? key}) : super(key: key);

  @override
  State<ResetEmailScreen> createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController=TextEditingController();
  final _userId=Authenticator().user?.uid;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppTexts.instance.changeEmail)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email to receive a reset link.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
               onPressed: (){
                 Authenticator().resetPassword(_emailController.text,);
               },
                icon: Icon(Icons.send),
                label: Text("Send Reset Link"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
