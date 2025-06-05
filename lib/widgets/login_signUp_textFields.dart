import 'package:flutter/material.dart';

import '../constants/texts.dart';

class LoginSignupTextfields extends StatelessWidget {
  String labelText;
  Widget icon;
  bool isOn;
  TextEditingController? controller;
   String? Function(String?)? validator;
   LoginSignupTextfields({super.key,required this.icon,required this.labelText,required this.isOn, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
        controller:controller,
        obscureText: isOn,
        decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    )));
  }
}
