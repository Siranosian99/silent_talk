import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/chat/model/ai_response_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/services/ai_backend.dart';
import '../services/ai_api.dart';

class PreviousAiScreenDetailed extends StatefulWidget {
  final String docId;
  const PreviousAiScreenDetailed({super.key,required this.docId});

  @override
  State<PreviousAiScreenDetailed> createState() => _PreviousAiScreenDetailedState();
}

class _PreviousAiScreenDetailedState extends State<PreviousAiScreenDetailed> {
  final TextEditingController searchController = TextEditingController();
  final Authenticator _authenticator=Authenticator();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiBotApiService>().getMessageById(widget.docId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/icons/ai-assistant.png'),
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.ai),
            IconButton(onPressed: (){
              context.goNamed('previousAi');
            }, icon: Icon(Icons.history))
          ],
        ),
      ),
      body: Consumer<AiBotApiService>(
        builder: (context, provider, child) {
          return
            ListView(
              padding: const EdgeInsets.all(12),
              children: provider.aiPrevious.expand((chat) {
                return chat.messages.map((msg) {
                  final isUser = msg.role == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(
                            isUser ? 18 : 0,
                          ),
                          bottomRight: Radius.circular(
                            isUser ? 0 : 18,
                          ),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            );
        },
      ),
    );
  }
}
//Center(child: Text(provider.aiPrevious[0].messages[1].text));


// Column(
//             children: [
//               Expanded(
//                 child:
//                 provider.aiReply.isEmpty
//                     ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/icons/ai-assistant.png',
//                       scale: 3,
//                     ),
//                     Text(
//                       'AI BOT\nHow i can help you',
//                       textAlign:TextAlign.center,
//                       style: TextStyle(fontWeight: FontWeight.bold,),
//                     ),
//                   ],
//                 )
//                     : ListView.separated(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: provider.aiReply.length,
//                   separatorBuilder:
//                       (_, __) => const SizedBox(height: 8),
//                   itemBuilder: (context, index) {
//                     final msg = provider.aiReply[index];
//                     final isUser = msg.role == 'user';
//
//                     return Align(
//                       alignment:
//                       isUser
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color:
//                           isUser
//                               ? Colors.blueAccent
//                               : Colors.grey.shade300,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(18),
//                             topRight: const Radius.circular(18),
//                             bottomLeft: Radius.circular(
//                               isUser ? 18 : 0,
//                             ),
//                             bottomRight: Radius.circular(
//                               isUser ? 0 : 18,
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           msg.content!,
//                           style: TextStyle(
//                             color:
//                             isUser ? Colors.white : Colors.black87,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(width: 16),
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child:
//                       provider.isLoading
//                           ? CircularProgressIndicator(strokeWidth: 2)
//                           : null,
//                     ),
//                     SizedBox(width: 10),
//                     provider.isLoading ? Text('AI is thinking...') : Text(''),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     enabled: !provider.isLoading,
//                     hintText:
//                     !provider.isLoading ? 'Chat with AI BOT' : 'Loading...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     suffixIcon: IconButton(
//                       icon:
//                       provider.isLoading
//                           ? Icon(Icons.stop)
//                           : Icon(Icons.send),
//                       onPressed: () async {
//                         final query = searchController.text.trim();
//                         if (query.isNotEmpty) {
//                           await provider.getData(searchController.text.trim());
//                           final msg = provider.aiReply[0].content ??'';
//                           // AiBackend().sendAiMessage(msg,_authenticator.getUserId(),query);
//                           searchController.clear();
//                           if (!context.mounted) {
//                             return;
//                           }
//                           if (provider.errorMessage.isNotEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(provider.errorMessage),
//                                 backgroundColor: Colors.red,
//                                 behavior: SnackBarBehavior.floating,
//                                 duration: const Duration(seconds: 3),
//                               ),
//                             );
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
