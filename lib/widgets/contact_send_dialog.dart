import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showContactDialog(
    BuildContext context,
    String contactName,
    String contactNumber,
    VoidCallback onTap,
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            CircleAvatar(
              child: Icon(Icons.person, color: Colors.white),
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
            Text(
              "Name: $contactName",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "Phone: $contactNumber",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              onTap();
              context.pop();
            },
            icon: Icon(Icons.send),
            label: Text("Send"),
          ),
        ],
      );
    },
  );
}
