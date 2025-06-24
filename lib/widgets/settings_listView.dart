import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/database/sqflite_imagesave.dart';
import 'package:silent_talk/widgets/settings_listTile.dart';
import 'package:silent_talk/widgets/settings_section_title.dart';
import 'package:silent_talk/widgets/show_image_dialog.dart';

import '../constants/texts.dart';
import '../service/model/user_model.dart';
import '../service/users/users_service.dart';
import '../utils/image_picker/image_camera_picker.dart';
import 'delete_dialog.dart';

class SettingsListView extends StatefulWidget {
  const SettingsListView({super.key});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  late final data;
  final UsersService _usersService = UsersService();
  late final Authenticator _auth;
  final _picker = Picker();
  late final picture;

  Future<void> callImageLink() async {
    data = await _usersService.getUserData();
    setState(() {});
  }

  @override
  void initState() {
    getDataFromSql();
    _auth = Authenticator();
    callImageLink();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    callImageLink();
    getDataFromSql();
    super.didChangeDependencies();
  }

  Future<void> getDataFromSql() async {
    final test = await ImageSaverOffline.getPhotoByUserId(Authenticator.user!.uid);
    setState(() {
      picture = test;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),

        // Profile Section
        Center(
          child: GestureDetector(
            onTap: () async {
              showImageSourceDialog(context);
              await ImageSaverOffline.savePhotoOffline(
                Authenticator.user!.uid,
                _picker.imgPath!,
              );

              print("path is :${_picker.imgPath!}");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  _picker.imgPath != null
                      ? Image.file(File(picture['path']), fit: BoxFit.cover)
                      : Image.asset(
                        'assets/images/noProfile.png',
                        fit: BoxFit.cover,
                      ),
              // CircleAvatar(
              //   radius: 50,
              //   backgroundImage: data?['image'].isEmpty
              //       ? AssetImage('assets/images/noProfile.png')
              //       :  NetworkImage(data?['image']),
              // ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            AppTexts.instance.userName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 24),

        // Section: Account
        sectionTitle('Account'),
        SettingsListtile(
          title: const Text('Edit Username'),
          leading: const Icon(Icons.edit),
          onTap: () {
            context.goNamed('updateUserName');
          },
        ),
        SettingsListtile(
          title: const Text('Change Email'),
          leading: const Icon(Icons.email),
          onTap: () {
            context.goNamed('updateEmail');
          },
        ),
        SettingsListtile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Change Password'),
          onTap: () {
            context.goNamed('insideApp');
          },
        ),
        // Section: Appearance
        sectionTitle('Appearance'),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          trailing: Switch(value: false, onChanged: null),
        ),
        SettingsListtile(
          leading: const Icon(Icons.palette),
          title: const Text('App Theme'),
          subtitle: const Text('Light / Dark / System'),
          onTap: () {
            print(picture);
          },
        ),

        // Section: Notifications
        sectionTitle('Notifications'),
        SettingsListtile(
          leading: const Icon(Icons.notifications),
          title: const Text('Message Notifications'),
          trailing: Switch(value: true, onChanged: null),
        ),
        SettingsListtile(
          leading: const Icon(Icons.vibration),
          title: const Text('Sound & Vibration'),
          trailing: Switch(value: false, onChanged: null),
        ),

        // Section: Security & Privacy
        sectionTitle('Privacy & Security'),
        SettingsListtile(
          leading: const Icon(Icons.lock),
          title: const Text('Enable Security'),
          trailing: Switch(value: false, onChanged: null),
        ),
        SettingsListtile(
          leading: const Icon(Icons.fingerprint),
          title: const Text('Biometric Authentication'),
          trailing: Switch(value: false, onChanged: null),
        ),
        SettingsListtile(
          leading: const Icon(Icons.visibility),
          title: const Text('Last Seen'),
          subtitle: const Text('Everyone'),
          onTap: () {},
        ),

        // Section: General
        sectionTitle('General'),
        SettingsListtile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English'),
          onTap: () {},
        ),
        SettingsListtile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About App'),
          onTap: () {},
        ),
        SettingsListtile(
          leading: const Icon(Icons.feedback),
          title: const Text('Send Feedback'),
          onTap: () {},
        ),

        const SizedBox(height: 24),

        // Log Out & Delete
        SettingsListtile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Log Out'),
          onTap: () {
            context.goNamed('/');
          },
        ),
        SettingsListtile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Delete Account'),
          onTap: () {
            showDeleteAccountDialog(context);
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
