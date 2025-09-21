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


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UsersService _usersService=UsersService();
   Map<String,dynamic>? data;
  String img='';
  // late final Authenticator _auth;
  // late final picture;

Future<void> callUserData() async {
  final user=await _usersService.getUserData();
  setState(() {
    data=user;
    img= data?['image'];
  });
}

@override
void initState() {
  // getDataFromSql();
  // _auth = Authenticator();
  callUserData();
  super.initState();
}

// @override
// void didChangeDependencies() {
//   callUserData();
//   // getDataFromSql();
//   super.didChangeDependencies();
// }

  // @override
  // void initState() {
  //   callImageLink();
  //   super.initState();
  // }

  // Future<void> callImageLink()async{
  //   data = (await _usersService.getUserData())!;
  //   setState(() {
  //     data;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          context.goNamed('people');
        }, icon: Icon(Icons.navigate_before)),
        title: Text(AppTexts.instance.settings),
        centerTitle: true,
      ),
      body:data == null ? const Center(child: CircularProgressIndicator()):ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),

          // Profile Section
          Center(
            child: GestureDetector(
              // onTap: () async {
              //   showImageSourceDialog(context);
              //   await ImageSaverOffline.savePhotoOffline(
              //     Authenticator.user!.uid,
              //     _picker.imgPath!,
              //   );
              //
              //   print("path is :${_picker.imgPath!}");
              // },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:
                img.isEmpty ?Image.asset(
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
            leading: Icon(themeProvider.isDark ? Icons.dark_mode :Icons.light_mode),
            title: Text(themeProvider.isDark ?'Dark Mode': 'Light Mode'),
            trailing: Switch(value: themeProvider.isDark, onChanged: (value)=>
                themeProvider.themeSwitch()),
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
      )
    );
  }
}

