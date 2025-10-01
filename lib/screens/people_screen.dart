import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/notification/get_token.dart';
import 'package:silent_talk/service/notification/notification_helper.dart';
import 'package:silent_talk/service/notification/notification_shower.dart';
import 'package:silent_talk/service/users/users_service.dart';

import '../l10n/app_localizations.dart';
import '../service/model/user_model.dart';
import '../tsesgty.dart';
import '../utils/biometric/auth.dart';
import '../widgets/chats_gridView.dart';
import '../widgets/chats_searchBar.dart';

class PeopleScreen extends StatefulWidget {
  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  late List<Users> users=[];
  UsersService _usersService=UsersService();
  Future<void> callUsers()async{
    users=await _usersService.fetchAllUsers();
  }
  @override
  void didChangeDependencies() {
    callUsers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( AppLocalizations.of(context)!.chats),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            context.pushNamed('settings');
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          // Search bar
          ChatSearchBar(controller:TextEditingController(), onChanged:(value){
            value = 'Esref Tek';
          }),
          SizedBox(height: 20,),
          // Grid of users
          Expanded(
            child: ChatsGridView(),
          ),
        ],
      ),
    );
  }
}




