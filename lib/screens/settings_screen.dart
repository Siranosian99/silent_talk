import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';
import '../service/authenticator/authenticator.dart';
import '../service/users/users_service.dart';
import '../utils/themes/theme_provider.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/settings_listTile.dart';
import '../widgets/settings_listView.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/show_image_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UsersService _usersService = UsersService();
  Map<String, dynamic>? data;
  String img = '';

  Future<void> callUserData() async {
    final user = await _usersService.getUserData();
    setState(() {
      data = user;
      img = data?['image'];
    });
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.instance.settings),
        centerTitle: true,
      ),
      body:
          data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 16),

                  // Profile Section
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                       await showImageSourceDialog(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            img.isEmpty
                                ? Image.asset(
                                  'assets/images/noProfile.png',
                                  fit: BoxFit.cover,
                                )
                                // picture['path'] != null
                                // ? Image.file(File(picture['path']), fit: BoxFit.cover)
                                : Image.network(img),
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
                      data?['userName'],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section: Account
                  sectionTitle(AppTexts.instance.account),
                  SettingsListtile(
                    title:  Text(AppTexts.instance.changeUserName),
                    leading: const Icon(Icons.edit),
                    onTap: () {
                      context.pushNamed('updateUserName');
                    },
                  ),
                  SettingsListtile(
                    title:  Text(AppTexts.instance.changeEmail),
                    leading: const Icon(Icons.email),
                    onTap: () {
                      context.pushNamed('updateEmail');
                    },
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.lock_outline),
                    title:  Text(AppTexts.instance.passChange),
                    onTap: () {
                      context.pushNamed('insideApp');
                    },
                  ),
                  // Section: Appearance
                  sectionTitle(AppTexts.instance.appearance),
                  ListTile(
                    leading: Icon(
                      themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: Text(
                      themeProvider.isDark ? AppTexts.instance.isDark : AppTexts.instance.isLight,
                    ),
                    trailing: Switch(
                      value: themeProvider.isDark,
                      onChanged: (value) => themeProvider.themeSwitch(),
                    ),
                  ),
                  // Section: Notifications
                  sectionTitle(AppTexts.instance.notification),
                  SettingsListtile(
                    leading: const Icon(Icons.notifications),
                    title: Text(AppTexts.instance.messages),
                    trailing: Switch(value: true, onChanged: null),
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.vibration),
                    title:  Text(AppTexts.instance.soundVib),
                    trailing: Switch(value: false, onChanged: null),
                  ),

                  // Section: Security & Privacy
                  sectionTitle(AppTexts.instance.security),
                  SettingsListtile(
                    leading: const Icon(Icons.lock),
                    title:  Text(AppTexts.instance.isSecure),
                    trailing: Switch(value: false, onChanged: null),
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.fingerprint),
                    title:  Text(AppTexts.instance.isBioMetric),
                    trailing: Switch(value: false, onChanged: null),
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.visibility),
                    title:  Text(AppTexts.instance.lastSeen),
                    subtitle: const Text('Everyone'),
                    onTap: () {},
                  ),

                  // Section: General
                  sectionTitle(AppTexts.instance.general),
                  SettingsListtile(
                    leading: const Icon(Icons.language),
                    title:  Text(AppTexts.instance.language),
                    subtitle: const Text('English'),
                    onTap: () {},
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.info_outline),
                    title:  Text(AppTexts.instance.about),
                    onTap: () {},
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.feedback),
                    title:  Text(AppTexts.instance.feedBack),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // Log Out & Delete
                  SettingsListtile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(AppTexts.instance.logOut),
                    onTap: () {
                      context.goNamed('/');
                    },
                  ),
                  SettingsListtile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: Text(AppTexts.instance.deleteAccount),
                    onTap: () {
                      showDeleteAccountDialog(context);
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
    );
  }
}
