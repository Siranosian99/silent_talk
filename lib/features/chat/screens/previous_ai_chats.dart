import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/chat/model/ai_chat_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/services/ai_backend.dart';
import '../services/ai_api.dart';

class PreviousAiChatsScreen extends StatefulWidget {
  const PreviousAiChatsScreen({super.key});

  @override
  State<PreviousAiChatsScreen> createState() => _PreviousAiChatsScreenState();
}

class _PreviousAiChatsScreenState extends State<PreviousAiChatsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/icons/ai-assistant.png'),
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.ai_history),
          ],
        ),
      ),
      body: Consumer<AiBotApiService>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                provider.aiReply.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/ai-assistant.png',
                      scale: 3,
                    ),
                    Text(
                      'There is No Old Conversations',
                      textAlign:TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                  ],
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.aiReply.length,
                  separatorBuilder:
                      (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final msg = provider.aiReply[index];
                    final isUser = msg.role == 'user';

                    return Align(
                      alignment:
                      isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                          isUser
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
                          msg.content!,
                          style: TextStyle(
                            color:
                            isUser ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),


            ],
          );
        },
      ),
    );
  }
}
