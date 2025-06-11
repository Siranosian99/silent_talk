import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/users/users_service.dart';

import '../contact/send_contact.dart';
import '../service/model/user_model.dart';
import '../widgets/chats_gridView.dart';
import '../widgets/chats_searchBar.dart';

class PeopleScreen extends StatefulWidget {
  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  // final List<Map<String, String>> users = List.generate(
  //   15,
  //       (index) => {
  //     'name': 'User $index',
  //     'image': 'https://i.pravatar.cc/150?img=${index + 1}',
  //   },
  // );
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
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            context.goNamed('settings');
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          // Search bar
          ChatsSearchBar(),

          // Grid of users
          Expanded(
            child: ChatsGridView(),
          ),
        ],
      ),
    );
  }
}




