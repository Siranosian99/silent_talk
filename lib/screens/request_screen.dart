import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';

import '../service/authenticator/request_check.dart';
import '../service/model/request_model.dart';
import '../service/model/user_model.dart';
import '../service/users/user_details/users_service.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  // late List<Users> users = [];
  // Map<String, dynamic>? data;
  final UsersService _usersService = UsersService();




  @override
  void initState() {
    // callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance
            .collection('requests')// Chat ID
            .where('requestReceiverId', isEqualTo: Authenticator.user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading messages'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final senderId = data['requestSenderId'];
              return FutureBuilder<Map<String, dynamic>?>(

                future: _usersService.getUserDataById(senderId), // async call
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading user...'));
                  }
                  final userData = userSnapshot.data!;

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
                        GestureDetector(
                          onLongPress: (){
                            print(senderId);
                          },

                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(userData['image']),
                            backgroundColor: Colors
                                .grey[200], // optional placeholder background
                          ),
                        ),
                        SizedBox(width: 12,),
                        // Username + Full name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['userName'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Accept Button
                        Column(
                          children: [
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
                              child: Text("Accept"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("Accepted request #$index");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }));}
  }





