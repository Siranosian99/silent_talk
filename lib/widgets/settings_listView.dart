import 'package:flutter/material.dart';
import 'package:silent_talk/widgets/settings_listTile.dart';
import 'package:silent_talk/widgets/settings_section_title.dart';

import '../constants/texts.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),

        // Profile Section
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/default_avatar.png'),
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
        SettingsListtile(title: const Text('Edit Username'), leading: const Icon(Icons.edit), onTap: () {},),
        SettingsListtile(title: const Text('Change Email'), leading:  const Icon(Icons.email), onTap: () {},),
        SettingsListtile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Change Password'),
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
        ),
        SettingsListtile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Delete Account'),
          onTap: () {},
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}