import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountEdits{
  Future<void> updatePassword(String newPass,String user_id)async{
   await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .update({
      'password': newPass,
    });
  }
  Future<void> updateUserName()async{}
  Future<void> updateEmail()async{}

}