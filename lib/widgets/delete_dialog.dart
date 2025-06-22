import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Delete Account"),
      content: Column(
        mainAxisSize: MainAxisSize.min ,
        children: [
          const Text("Are you sure you want to delete your account?"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.cancel, color: Colors.white),
                label: Text("No"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.check, color: Colors.white),
                label: Text("Yes"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  GoRouter.of(context).goNamed('login');
                  Authenticator().deleteAccount();
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
