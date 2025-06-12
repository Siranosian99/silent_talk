import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/model/user_model.dart';

import '../service/users/users_service.dart';

class ChatsGridView extends StatefulWidget {
  ChatsGridView({super.key});

  @override
  State<ChatsGridView> createState() => _ChatsGridViewState();
}

class _ChatsGridViewState extends State<ChatsGridView> {
  // );
  late List<Users> users = [];
  UsersService _usersService = UsersService();

  Future<void> callUsers() async {
    users = await _usersService.fetchAllUsers();
    setState(() {
      users;
    });
  }

  @override
  void initState() {
    callUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
                GoRouter.of(context).goNamed(
                  'chat',
                  pathParameters: {
                    'id': '$index',
                    'senderId': Authenticator.user!.uid,
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
    );
  }
}
