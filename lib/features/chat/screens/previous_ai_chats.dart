import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/chat/model/ai_response_model.dart';
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
  final Authenticator _authenticator =Authenticator();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiBotApiService>().getMessagesById(_authenticator.getUserId());
    });
  }


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
                    provider.aiPreviousList.isEmpty
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
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: provider.aiPreviousList.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.smart_toy_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  provider.aiPreviousList[index].messages[index].text,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          provider.aiPreviousList[index].messages[index].text,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(height: 8,),
                                      Text(
                                        '${provider.aiPreviousList[index].createdAt.day.toString().padLeft(2, '0')}.'
                                        '${provider.aiPreviousList[index].createdAt.month.toString().padLeft(2, '0')}.'
                                        '${provider.aiPreviousList[index].createdAt.year} '
                                        '${provider.aiPreviousList[index].createdAt.hour.toString().padLeft(2, '0')}:'
                                        '${provider.aiPreviousList[index].createdAt.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                                onTap: () {
                                  context.goNamed("detailedPreviousAi",extra:provider.aiPreviousList[index].id );
                                },
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
