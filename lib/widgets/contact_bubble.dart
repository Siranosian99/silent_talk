import 'package:flutter/material.dart';

final Container contactContainer=Container(
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
    border: Border(
      left: BorderSide(color: Colors.green.shade600, width: 4),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.person, size: 30, color: Colors.green.shade700),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Doe",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "+1 234 567 890",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 12),
      InkWell(
        onTap: () {
          // handle add to contacts
        },
        child: Row(
          children: [
            Icon(Icons.person_add, color: Colors.green.shade700, size: 20),
            SizedBox(width: 6),
            Text(
              "Add to contacts",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
