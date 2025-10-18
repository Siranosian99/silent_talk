import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/utils/biometric/auth.dart';
import 'package:silent_talk/utils/last_seen/last_seen_provider.dart';
import '../l10n/app_localizations.dart';
import '../service/authenticator/authenticator.dart';
import '../service/users/user_details/users_service.dart';
import '../utils/biometric/auth_provider.dart';
import '../utils/themes/theme_provider.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/language_dropDown.dart';
import '../widgets/settings_listTile.dart';
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
  bool? isAuth;

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
    final authProvider = Provider.of<AuthenticateProvider>(context);
    final lastProvider = Provider.of<LastSeenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
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
                  sectionTitle(AppLocalizations.of(context)!.account),
                  SettingsListtile(
                    title: Text(AppLocalizations.of(context)!.changeUserName),
                    leading: const Icon(Icons.edit),
                    onTap: () {
                      context.pushNamed('updateUserName');
                    },
                  ),
                  SettingsListtile(
                    title: Text(AppLocalizations.of(context)!.changeEmail),
                    leading: const Icon(Icons.email),
                    onTap: () {
                      context.pushNamed('updateEmail');
                    },
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(AppLocalizations.of(context)!.passChange),
                    onTap: () {
                      context.pushNamed('insideApp');
                    },
                  ),
                  // Section: Appearance
                  sectionTitle(AppLocalizations.of(context)!.appearance),
                  ListTile(
                    leading: Icon(
                      themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: Text(
                      themeProvider.isDark
                          ? AppLocalizations.of(context)!.isDark
                          : AppLocalizations.of(context)!.isLight,
                    ),
                    trailing: Switch(
                      value: themeProvider.isDark,
                      onChanged: (value) => themeProvider.themeSwitch(),
                    ),
                  ),
                  // Section: Notifications
                  sectionTitle(AppLocalizations.of(context)!.notification),
                  SettingsListtile(
                    leading: const Icon(Icons.notifications),
                    title: Text(AppLocalizations.of(context)!.messages),
                    trailing: Switch(value: true, onChanged: null),
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.vibration),
                    title: Text(AppLocalizations.of(context)!.soundVib),
                    trailing: Switch(value: false, onChanged: null),
                  ),

                  // Section: Security & Privacy
                  sectionTitle(AppLocalizations.of(context)!.security),
                  SettingsListtile(
                    onTap: ()async {

                    },
                    leading:  Icon(authProvider.isAuth ?Icons.lock_open_outlined:Icons.lock),
                    title: Text(AppLocalizations.of(context)!.isSecure),
                    trailing: Switch(value: authProvider.isAuth, onChanged: (value)=> authProvider.authChange()),
                  ),
                  // SettingsListtile(
                  //   leading: const Icon(Icons.fingerprint),
                  //   title:  Text(AppLocalizations.of(context)!.isBioMetric),
                  //   trailing: Switch(value: false, onChanged: null),
                  // ),
                  SettingsListtile(
                    leading: lastProvider.isSeen ? Icon(Icons.visibility):Icon(Icons.visibility_off),
                    title: Text(AppLocalizations.of(context)!.lastSeen),
                    trailing: Switch(value: lastProvider.isSeen, onChanged: (value)=> lastProvider.lastSeenSwitch()),

                  ),

                  // Section: General
                  sectionTitle(AppLocalizations.of(context)!.general),
                  SettingsListtile(subtitle: LanguageDropdown(), onTap: () {}),
                  SettingsListtile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(AppLocalizations.of(context)!.about),
                    onTap: () {},
                  ),
                  SettingsListtile(
                    leading: const Icon(Icons.feedback),
                    title: Text(AppLocalizations.of(context)!.feedBack),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // Log Out & Delete
                  SettingsListtile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(AppLocalizations.of(context)!.logOut),
                    onTap: () async {
                     await Authenticator().signOut(context);
                    },
                  ),
                  SettingsListtile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: Text(AppLocalizations.of(context)!.deleteAccount),
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
