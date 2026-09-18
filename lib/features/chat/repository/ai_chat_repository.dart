import 'package:silent_talk/features/chat/services/ai_backend.dart';
import 'package:silent_talk/features/user/service/authenticator.dart';

import '../../user/repository/authenticator_repository.dart';
import '../model/ai_response_model.dart';
import '../model/chat_model.dart';

class AiChatRepository {
  final AiBackend _aiBackend;
  final AuthenticatorRepository _authenticator =AuthenticatorRepository(AuthenticatorService());
  AiChatRepository(this._aiBackend);
  Future<List<AiResponseModel>> getData(String query)async{
    return await _aiBackend.getData(query);
  }
  Future<List<ChatModel>> getMessagesById(String userId) async {
    return await _aiBackend.getMessagesById(
      _authenticator.getUserId(),
    );
  }

  Future<List<ChatModel>> getMessageById(String docId) async {
    return   await _aiBackend.getMessageById(docId);}

  Future<String?> sendAiMessageWithId(
      String userId,
      String docId,
      String userMessage,
      String aiMessage
      ) async {
    final message = await _aiBackend.sendAiMessageWithId(
      userId,
      docId,
      userMessage,
      aiMessage,
    );
    await getMessageById(docId);
    return message;
  }


}