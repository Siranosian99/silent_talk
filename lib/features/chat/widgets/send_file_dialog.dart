import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

Future<void> showFileDialog(
  BuildContext context,
  String fileName,
  Future<void> Function() onTap,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset('assets/icons/document.png'),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(fileName)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await onTap();
              if (!context.mounted) return;
              context.pop();
            },
            icon: Icon(Icons.send),
            label: const Text("Send"),
          ),
        ],
      );
    },
  );
}
