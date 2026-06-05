import 'package:flutter/material.dart';
import 'package:silent_talk/constants/texts.dart';

class ContactBubble extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final VoidCallback? onAdd;

  const ContactBubble({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow:const [
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
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    phoneNumber,
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
            onTap: onAdd,
            child: Row(
              children: [
                Icon(Icons.person_add, color: Colors.green.shade700, size: 20),
                SizedBox(width: 6),
                Text(
                  AppTexts.instance.contact,
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
  }
}
