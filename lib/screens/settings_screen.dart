import 'package:flutter/material.dart';
import 'package:silent_talk/constants/texts.dart';
import '../widgets/settings_listView.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.instance.settings),
        centerTitle: true,
      ),
      body: SettingsListView(),
    );
  }


}

