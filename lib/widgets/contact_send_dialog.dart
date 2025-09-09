import 'package:flutter/material.dart';

void showContactDialog(BuildContext context, String contactDetials) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:const Row(
          children: [
            CircleAvatar(
              child: const Icon(Icons.person, color: Colors.white),
              backgroundColor: Colors.blue,
            ),
            SizedBox(width: 12),
            Text("Contact"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contactDetials, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () {
            },
            icon: Icon(Icons.send),
            label: Text("Send"),
          ),
        ],
      );
    },
  );
}
