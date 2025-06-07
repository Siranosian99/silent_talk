import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactCard extends StatelessWidget {
  final String message;

  const ContactCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = message.split('\n');
    final nameLine = lines.length > 1 ? lines[1] : '';
    final phoneLine = lines.length > 2 ? lines[2] : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📇 Contact Info', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            Text(nameLine, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(phoneLine, style: TextStyle(fontSize: 16)),

          ],
        ),
      ),
    );
  }
}
