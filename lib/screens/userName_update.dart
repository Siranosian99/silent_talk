import 'package:flutter/material.dart';
import 'package:silent_talk/constants/texts.dart';

import '../service/authenticator/authenticator.dart';

class UpdateUserNameScreen extends StatefulWidget {
  const UpdateUserNameScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserNameScreen> createState() => _UpdateUserNameScreenState();
}

class _UpdateUserNameScreenState extends State<UpdateUserNameScreen> {
  final _userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Email')),
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
                controller: _userName,
                decoration: InputDecoration(
                  labelText: "UserName",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_open_outlined),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter a valid username";
                  }
                  if (value.length < 3) {
                    return "Username must be at least 3 characters";
                  }
                  return null;
                }
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: (){
                  Authenticator().updateUserName(_userName.text,);
                },
                icon: Icon(Icons.update),
                label: Text(AppTexts.instance.userName),
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
