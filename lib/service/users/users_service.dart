import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../authenticator/authenticator.dart';
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
      return snapshot.docs.where((doc) =>
      doc.id != Authenticator.user?.uid
      ) // hide current user
          .map((doc) {
        return Users(
            deviceId: doc['deviceId'],
            lastSeen:doc['lastSeen'],
            id: doc['id'],
            name: doc['name'],
            userName: doc['userName'],
            email: doc['email'],
            password: doc['password'],
            token: doc['token'],
            image: doc['image'],
            isOnline: doc['isOnline'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {

    if (Authenticator.user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(Authenticator.user?.uid)
        .get();

    if (!doc.exists) return null;
    return doc.data(); // ✅ This gives you a Map<String, dynamic>
  }
}
