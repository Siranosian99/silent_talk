import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String imgLink =
        "https://i1.sndcdn.com/artworks-000693861175-aj6nwe-t500x500.jpg";
    String userName = "Name Lastname";
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imgLink),
                ),
                SizedBox(height: 15),
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Hello!.........?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Heeeeey",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),

          TextFormField(
            decoration: InputDecoration(
              hintText: "Type a message...",
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  // Select file logic
                },
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Send message logic
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
