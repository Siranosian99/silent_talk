import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

Future<void> showFileDialog(
    BuildContext context,
    String fileName,
    VoidCallback onTap,
    )async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset('assets/icons/document.png'),
            ),
            const SizedBox(width: 12),
            Text(fileName),
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
