import 'dart:io';
import 'package:flutter/material.dart';

import '../service/model/user_model.dart';
import '../service/users/user_details/users_service.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late List<Users> users = [];
  Map<String, dynamic>? data;
  final UsersService _usersService = UsersService();

  Future<void> callUsers(String query) async {
    users = await _usersService.fetchAllUsers(query) ?? [];
    setState(() {
      users;
    });
  }

  Future<void> callUserData() async {
    final user = await _usersService.getRequests(recieverId);
    setState(() {
      data = user;
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
        title: const Text("Requests"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(users[index].image),
                  backgroundColor: Colors.grey[200], // optional placeholder background
                ),


                // Username + Full name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        users[index].userName,
                        style: const TextStyle(
                          color:Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       Text(
                        users[index].name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Accept Button
                ElevatedButton(
                  onPressed: () {
                    print("Accepted request #$index");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child:  Text("${ users[index].password}"),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
