import 'dart:io';
import 'package:flutter/material.dart';

class FileViewer extends StatelessWidget {
  final String filePath;

  const FileViewer({super.key, required this.filePath}); // Path to your file



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filePath.split('/').last),
      ),
      body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              filePath,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'monospace', // makes it look like a document
              ),
            )));
  }
}
