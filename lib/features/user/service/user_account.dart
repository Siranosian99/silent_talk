import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAccountEdits {
  final user = FirebaseAuth.instance.currentUser;

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
  Future<void> updateProilePhoto(String image) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'image': image});
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await user?.verifyBeforeUpdateEmail(email);
      await user?.reload();
      print(
        '📨 Verification email sent to $email. Email will update after verification.',
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'email': email});
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
          .update({'userName': userName});
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
//
}
