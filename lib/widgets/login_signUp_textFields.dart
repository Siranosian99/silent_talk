import 'package:flutter/material.dart';

import '../constants/texts.dart';

class LoginSignupTextfields extends StatelessWidget {
  String labelText;
  Widget icon;
  bool isOn;
   LoginSignupTextfields({super.key,required this.icon,required this.labelText,required this.isOn});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: isOn,
        decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    )));
  }
}
