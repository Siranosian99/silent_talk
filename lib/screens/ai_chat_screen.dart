import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/service/model/ai_chat_model.dart';

import '../l10n/app_localizations.dart';
import '../service/ai/ai_api.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

  List<AiChatModel> ai=[];
  late final provider ;
  final bool cvalue=false;

  @override
  void didChangeDependencies() {
    provider=Provider.of<AIbotApiService>(context);
    getData();
    super.didChangeDependencies();
  }
  Future<void>getData()async{
    ai=await provider.getData('count from 0 to 10');
    setState(() {
      ai;
    });
  }
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
      body:ai.isEmpty?Center(child: CircularProgressIndicator()):Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: ai[0].role =='assistant'  ? AlignmentGeometry.topLeft :AlignmentGeometry.topRight,
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
                           ai[0].content ?? 'no Data'   ,
                        style: TextStyle(
                          color: cvalue ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
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
          ),

        ],
      ),
    );
  }
}
