import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/user_model.dart';
import '../repository/authenticator_repository.dart';
import 'authenticator.dart';

class UsersService {
  CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );
  final AuthenticatorRepository _authenticator =AuthenticatorRepository(AuthenticatorService());

  Future<List<Users>?> fetchAllUsers(String name) async {
    try {
      // Fetch all documents from the Category collection
      QuerySnapshot? snapshot;
      if(name.isEmpty){
        snapshot=  await users.get();
      }
      else if(name.isNotEmpty){
        snapshot = await users
            .where('name', isGreaterThanOrEqualTo: name)
            .where('name', isLessThanOrEqualTo: name + '\uf8ff')
            .get();

      }

      // Map each document to its data
      return snapshot?.docs.where((doc) =>
      doc.id != _authenticator.getUserId()
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
          isNotification: doc['isNotification']
        );
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }



  Future<Map<String, dynamic>?> getUserData() async {

    // if (_authenticator.getUserId() == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_authenticator.getUserId())
        .get();

    if (!doc.exists) return null;
    return doc.data();
  }
  Future<Map<String, dynamic>?> getUserDataById(String id) async {

    // if (_authenticator.getUserId() == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();

    if (!doc.exists) return null;
    return doc.data();
  }




}
