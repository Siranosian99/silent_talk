import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';

import 'package:silent_talk/service/users/users_service.dart';

import '../l10n/app_localizations.dart';
import '../service/model/user_model.dart';

import '../widgets/chats_searchBar.dart';

class PeopleScreen extends StatefulWidget {
  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final TextEditingController searchController = TextEditingController();


  late List<Users> users = [];
  final UsersService _usersService = UsersService();

  Future<void> callUsers(String query) async {
    users = await _usersService.fetchAllUsers(query) ?? [];
    setState(() {
      users;
    });
  }

  @override
  void initState() {
    callUsers('');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chats),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          ChatSearchBar(
            controller: searchController,
            onChanged: (value) {
            callUsers(value);
            },
          ),
          SizedBox(height: 20),
          // Grid of users
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: users.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          'chat',
                          extra: {
                            'id': user.id,
                            'senderId': Authenticator.user?.uid,
                            'receiverId': user.id,
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            user.image.isEmpty
                                ? AssetImage('assets/images/noProfile.png')
                                : NetworkImage(user.image),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
