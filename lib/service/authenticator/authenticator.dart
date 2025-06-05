import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/user_model.dart';

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = firestore.collection('users');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> createUser(
    String name,
    String userName,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      Users userInfo = Users(
        name: name,
        userName: userName,
        email: email,
        password: password,
        token: '',
      );
      userCredential.user?.sendEmailVerification();
      await users
          .doc(uid)
          .set(userInfo.toMap(userInfo) as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth errors
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Email is already in use.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        default:
          throw Exception('Authentication error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool?> checkVerify() async {
    bool? isVerified = user?.emailVerified;
    return isVerified;
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user's email is verified
      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(
          ctx,
        ).showSnackBar(SnackBar(content: Text('Verify Email')));
        userCredential.user?.sendEmailVerification();
      } else {
        ctx.goNamed('chat');
        print('Login successful!');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> resetPassword(String email) async {
    // String? userEmail=user?.email;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    await user?.delete();
  }
}
