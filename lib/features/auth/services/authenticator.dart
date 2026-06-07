import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/notification/get_token.dart';
import '../../../core/utils/time_format/time_convertor.dart';
import '../../user/service/get_userIds.dart';
import '../../user/model/user_model.dart';
import 'get_deviceId.dart';

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = firestore.collection('users');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isLoggedOut=false;

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
      String utoken = await GetToken.getToken();
      final deviceId = await DeviceIdHelper().getDeviceId();
      Users userInfo = Users(
        id: uid,
        deviceId: deviceId,
        image: image,
        name: name,
        userName: userName,
        email: email,
        password: password,
        token: utoken,
        lastSeen: lastSeenFormat(DateTime.now()),
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
      await FirebaseAuth.instance.currentUser?.reload();
      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(
          ctx,
        ).showSnackBar(SnackBar(content: Text('Verify Email')));
        userCredential.user?.sendEmailVerification();
        await FirebaseAuth.instance.currentUser?.reload();
      } else {
        final user = FirebaseAuth.instance.currentUser;
        await user?.reload();
        ctx.goNamed('people');
        print('Login successful!');
        // String utoken = await GetToken.getToken();
        final deviceId = await DeviceIdHelper().getDeviceId();
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid);
        final snapshot = await docRef.get();
        // Platform.isAndroid ? await FirebaseFirestore.instance.collection('users').doc(user?.uid).set(
        //   {'token': utoken, 'deviceId': deviceId},
        //   SetOptions(merge: true),
        // ):
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set(
          {'deviceId': deviceId},
          SetOptions(merge: true),
        );

        print("-----------"
            "This is SavedId in localStorage:$deviceId  "
            "this is NewID:${snapshot.data()?['deviceId']}");
        listenForAnotherDeviceLogin(ctx,deviceId);
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

  // Future<void> updateProilePhoto(String image) async {
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .update({'image': image});
  //   }
  // }
  //
  // Future<void> updateEmail(String email) async {
  //   try {
  //     await user?.verifyBeforeUpdateEmail(email);
  //     await user?.reload();
  //     print(
  //       '📨 Verification email sent to $email. Email will update after verification.',
  //     );
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .update({'email': email});
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       print('❌ This email is already registered.');
  //     } else if (e.code == 'requires-recent-login') {
  //       print('❌ Please re-authenticate before updating email.');
  //     } else {
  //       print('❌ Error: ${e.message}');
  //     }
  //   }
  //
  //   // if (user != null) {
  //   //   await FirebaseFirestore.instance
  //   //       .collection('users')
  //   //       .doc(user?.uid)
  //   //       .update({'email':email});
  //   // }
  // }
  //
  // Future<void> updateUserName(String userName) async {
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .update({'userName': userName});
  //   }
  // }

  // Future<void> fuckingPassword(String txt) async {
  //
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .update({'password':txt});
  //   }
  // }
  // Future<void> updateUserPassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     if (user == null) {
  //       throw FirebaseAuthException(
  //         code: 'no-user',
  //         message: 'No user is currently signed in.',
  //       );
  //     }
  //
  //     // Re-authenticate with current password
  //     final credential = EmailAuthProvider.credential(
  //       email: user?.email ?? '',
  //       password: currentPassword,
  //     );
  //
  //     await user?.reauthenticateWithCredential(credential);
  //
  //     // Now update to new password
  //     await user?.updatePassword(newPassword);
  //
  //     print('✅ Password updated successfully');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'wrong-password') {
  //       print('❌ The current password is incorrect.');
  //     } else if (e.code == 'requires-recent-login') {
  //       print('❌ You need to re-login before updating your password.');
  //     } else {
  //       print('❌ FirebaseAuth error: ${e.message}');
  //     }
  //   } catch (e) {
  //     print('❌ Unexpected error: $e');
  //   }
  // }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((_) async{
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'token': ''});
      }
      context.goNamed('login');
    });
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      final uid = user?.uid;

      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await user?.delete();
      final deviceId = await DeviceIdHelper().getDeviceId();
      listenForAnotherDeviceLogin(context,deviceId);
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

  // Future<void> updateImageField(String uid, String path) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //       'image': path,
  //     });
  //     print('Image updated successfully');
  //   } catch (e) {
  //     print('Failed to update image: $e');
  //   }
  // }

  // void anotherDeviceLoginListener(BuildContext context) async {
  //   if (user == null) return;
  //
  //   // Get current device token
  //   final token = await GetToken.getToken();
  //   if (token == null) return;
  //
  //   // Listen to the user document in Firestore
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user?.uid)
  //       .snapshots()
  //       .listen((snapshot) async {
  //         if (!snapshot.exists) return;
  //
  //         final currentDeviceToken = snapshot.data()?['token'];
  //
  //         print('-----------------------------------------');
  //         print('User token: $token  currentToken: $currentDeviceToken');
  //         print('-----------------------------------------');
  //
  //         // If token in Firestore is different, logout
  //         if (token != currentDeviceToken) {
  //           await FirebaseAuth.instance.signOut();
  //           if (context.mounted) {
  //             context.goNamed('login');
  //           }
  //           print('🚪 Logged out because another device logged in.');
  //         }
  //       });
  // }

  void listenForAnotherDeviceLogin(BuildContext context,String deviceId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) async {
          if (!snapshot.exists) return;

          final remoteId = snapshot.data()?['deviceId'];

          if (remoteId != deviceId) {
            await FirebaseAuth.instance.signOut();
            isLoggedOut=true;

            print("--------------------------- isLoggedOut:$isLoggedOut");
            if (context.mounted) {
              context.pushReplacementNamed('login');
            }
          }
        });
  }
}
