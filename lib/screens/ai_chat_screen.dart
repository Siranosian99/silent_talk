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
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AIbotApiService>(context);
    final aiMessages = provider.ai_reply;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/icons/ai-assistant.png'),
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.ai),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Chat messages ---
        provider.isFinished? Expanded(
            child: aiMessages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: aiMessages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final msg = aiMessages[index];
                final isUser = msg.role == 'user';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                        Radius.circular(isUser ? 18 : 0),
                        bottomRight:
                        Radius.circular(isUser ? 0 : 18),
                      ),
                    ),
                    child: Text(
                      msg.content!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ):Expanded(child: Center(child: Text("Getting Data Please Wait A Mommnet..."))),

          // --- Input field ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                enabled: provider.isFinished,
                hintText: provider.isFinished?'Chat with AI BOT':'Loading...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: IconButton(
                  icon: provider.isFinished?Icon(Icons.send):CircularProgressIndicator(),
                  onPressed: () {
                    if (searchController.text.trim().isNotEmpty) {
                      provider.getData(searchController.text.trim());
                      searchController.clear();
                      provider.isFinihsedChanger();

                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
