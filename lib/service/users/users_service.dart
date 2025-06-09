import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class UsersService {
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<List<Users>> fetchAllCategories() async {
    try {
      // Fetch all documents from the Category collection
      QuerySnapshot snapshot =
          await categories.orderBy("key", descending: false).get();

      // Map each document to its data
      return snapshot.docs.map((doc) {
        return Users(
          // Assign document ID
          id: doc['id'],
          name: doc['name'],
          userName: doc['userName'],
          email: doc['email'],
          password: doc['password'],
          token: doc['token'],
          image: doc['image'],// Assuming there’s a 'key' field in the category
        );
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
