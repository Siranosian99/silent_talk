import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class UsersService {
  CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<List<Users>> fetchAllUsers() async {
    try {
      // Fetch all documents from the Category collection
      QuerySnapshot snapshot =
          await users.get();

      // Map each document to its data
      return snapshot.docs.map((doc) {
        return Users(
          id: doc['id'],
          name: doc['name'],
          userName: doc['userName'],
          email: doc['email'],
          password: doc['password'],
          token: doc['token'],
          image: doc['image'],
          isOnline: doc['isOnline']
        );
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
