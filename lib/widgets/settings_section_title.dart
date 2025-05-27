import 'package:flutter/material.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );
}