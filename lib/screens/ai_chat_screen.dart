import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final bool cvalue=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Row(
          children: [
            CircleAvatar(
              radius: 25,
                backgroundImage: AssetImage('assets/icons/ai-assistant.png')),
            SizedBox(
              width: 12,
            ),
            Text(AppLocalizations.of(context)!.ai)
          ],
        ),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: cvalue ? AlignmentGeometry.topLeft :AlignmentGeometry.topRight,
            child:Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cvalue ? Colors.blueAccent : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(cvalue ? 18 : 0),
                      bottomRight: Radius.circular(cvalue ? 0 : 18),
                    ),
                  ),
                  child: Text(
                    'data',
                    style: TextStyle(
                      color: cvalue ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                )

              ],
            ),
          ),
          SizedBox(height: 700,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration:InputDecoration(
                hint:Text('Chat with AI BOT'),
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon:IconButton(onPressed: (){},icon:Icon(Icons.send))
              ),
            ),
          )
        ],
      ),
    );
  }
}
