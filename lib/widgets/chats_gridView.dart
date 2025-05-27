import 'package:flutter/material.dart';

class ChatsGridView extends StatelessWidget {
  const ChatsGridView({
    super.key,
    required this.users,
  });

  final List<Map<String, String>> users;

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
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(user['image']!),
            ),
            const SizedBox(height: 8),
            Text(
              user['name']!,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}