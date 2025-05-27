import 'package:flutter/material.dart';

class SettingsListtile extends StatelessWidget {
  Widget leading;
  Widget title;
  Widget? trailing;
  VoidCallback? onTap;
  Widget? subtitle;
   SettingsListtile({super.key,required this.title,required this.leading, this.trailing,this.onTap,this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:leading ,
      title: title,
      trailing:trailing ,
      onTap:onTap ,
      subtitle: subtitle,
    );
  }
}


// ListTile(
// leading: const Icon(Icons.email),
// title: const Text('Change Email'),
// onTap: () {},
// ),
//
// ListTile(
// leading: const Icon(Icons.dark_mode),
// title: const Text('Dark Mode'),
// trailing: Switch(value: false, onChanged: null),
// ),
// ListTile(
// leading: const Icon(Icons.palette),
// title: const Text('App Theme'),
// subtitle: const Text('Light / Dark / System'),
// onTap: () {},
// ),