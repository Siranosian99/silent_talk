import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/user_model.dart';

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = firestore.collection('users');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> createUser(
    String name,
    String userName,
    String email,
    String password,
    String image,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      Users userInfo = Users(
        id: uid,
        image: image,
        name: name,
        userName: userName,
        email: email,
        password: password,
        token: '',
        isOnline: false,
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
        ctx.goNamed('people');
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
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'lastPasswordReset': FieldValue.serverTimestamp()});
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await user?.verifyBeforeUpdateEmail(email);
      await user?.reload();
      print('📨 Verification email sent to $email. Email will update after verification.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('❌ This email is already registered.');
      } else if (e.code == 'requires-recent-login') {
        print('❌ Please re-authenticate before updating email.');
      } else {
        print('❌ Error: ${e.message}');
      }
    }



    // if (user != null) {
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(user?.uid)
    //       .update({'email':email});
    // }

  }
  Future<void> updateUserName(String userName) async {

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'userName':userName});
    }
  }
  // Future<void> fuckingPassword(String txt) async {
  //
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .update({'password':txt});
  //   }
  // }
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is currently signed in.',
        );
      }

      // Re-authenticate with current password
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );

      await user?.reauthenticateWithCredential(credential);

      // Now update to new password
      await user?.updatePassword(newPassword);

      print('✅ Password updated successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('❌ The current password is incorrect.');
      } else if (e.code == 'requires-recent-login') {
        print('❌ You need to re-login before updating your password.');
      } else {
        print('❌ FirebaseAuth error: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount(BuildContext context) async {

    try {
      final uid = user?.uid;

      if (uid == null) return;
      // 1. Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      // 2. Delete user from Firebase Authentication
      await user?.delete();
      context.goNamed('login');
      print('✅ User deleted from Auth and Firestore');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('❌ Please re-authenticate before deleting your account.');
        // You may want to redirect the user to a re-authentication screen here
      } else {
        print('❌ Error deleting account: ${e.message}');
      }
    }
  }

  Future<void> updateImageField(String uid, String path) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'image': path,
      });
      print('Image updated successfully');
    } catch (e) {
      print('Failed to update image: $e');
    }
  }
}
