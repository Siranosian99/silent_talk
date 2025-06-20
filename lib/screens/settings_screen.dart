import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/constants/texts.dart';
import '../service/users/users_service.dart';
import '../widgets/settings_listView.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
   Map<String,dynamic> data={};

  @override
  void initState() {
    callImageLink();
    super.initState();
  }
  final UsersService _usersService=UsersService();

  Future<void> callImageLink()async{
    data = (await _usersService.getUserData())!;
    setState(() {
      data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          context.goNamed('people');
        }, icon: Icon(Icons.navigate_before)),
        title: Text(AppTexts.instance.settings),
        centerTitle: true,
      ),
      body:SettingsListView()
    );
  }
}

