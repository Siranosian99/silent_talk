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
            child:,
            alignment: cvalue ? AlignmentGeometry.topLeft :AlignmentGeometry.topRight,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration:InputDecoration(
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
