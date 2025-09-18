import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/widgets/login_signUp_textFields.dart';

import '../utils/image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Authenticator auth= Authenticator();
  String? photoLink;
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _userNameController=TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final  picker=Picker();
  Future<String?> savePhoto()async{
   final link=await picker.galleryPicker();
      setState(() {
        photoLink=link;
      });
      return link;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              CircleAvatar(
                radius: 60,
                backgroundImage: photoLink!=null?NetworkImage(photoLink ?? ''):AssetImage('assets/images/noProfile.png'),
                child: Stack(
                  children: [
                   TextButton(onPressed: ()async{
                    savePhoto();
                   }, child: Text(photoLink == null?AppTexts.instance.addPhoto:''))
                  ],
                )
              ),
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
                controller: _userNameController,
                icon: Icon(Icons.person),
                labelText: AppTexts.instance.userName,
                isOn: false,
              ),
              SizedBox(height: 16),
              LoginSignupTextfields(
                controller:_nameController,
                icon: Icon(Icons.nature_people),
                labelText: AppTexts.instance.name,
                isOn: false,
              ),
              SizedBox(height: 16),
              LoginSignupTextfields(
                controller: _emailController,
                icon: Icon(Icons.email),
                labelText: AppTexts.instance.email,
                isOn: false,
              ),
              SizedBox(height: 16),
              LoginSignupTextfields(
                controller:_passwordController,
                icon: Icon(Icons.password),
                labelText: AppTexts.instance.password,
                isOn: true,
              ),
              SizedBox(height: 40),
              // Login Button
              ElevatedButton(
                onPressed: () async{
                  if(photoLink != null){
                    await  auth.createUser(_nameController.text, _userNameController.text, _emailController.text, _passwordController.text,photoLink ??'');
                  }
                  else {
                    return;
                  }



                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppTexts.instance.signUp,
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
    );
  }
}
