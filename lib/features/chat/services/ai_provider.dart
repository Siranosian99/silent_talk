import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/chat/model/ai_response_model.dart';
import 'package:silent_talk/features/chat/model/chat_model.dart';
import 'package:silent_talk/features/chat/repository/ai_chat_repository.dart';
import '../../../constants/api_consts.dart';
import '../../user/repository/authenticator_repository.dart';
import 'ai_backend.dart';
import '../../user/service/authenticator.dart';
import '../model/ai_message_model.dart';

class AiBotApiProvider with ChangeNotifier {
  bool isLoading = false;
  late String errorMessage;
  final AiBackend _aiBackend = AiBackend();
  final AuthenticatorRepository _authenticator =AuthenticatorRepository(AuthenticatorService());
  List<AiResponseModel> aiReply = [];
  List<ChatModel> aiPreviousList = [];
  List<ChatModel> aiPrevious = [];
  final AiChatRepository repository;

  AiBotApiProvider({required this.repository});

  Future<List<AiResponseModel>?> getData(String query) async {
    try {
      errorMessage = '';
      notifyListeners();
      final response = await repository.getData(query);
      aiReply.addAll(response);
      return aiReply;
    } catch (e) {
      errorMessage = e.toString();
      print("error send to AI api ${e.toString()}");
      return null;
    }
    // finally {
    //   isLoading = false;
    //   notifyListeners();
    // }
  }

  Future<List<ChatModel>> getMessagesById(String userId) async {
    aiPreviousList = await _aiBackend.getMessagesById(
      _authenticator.getUserId(),
    );
    notifyListeners();
    return aiPreviousList;
  }

  Future<List<ChatModel>> getMessageById(String docId) async {
    final message = await _aiBackend.getMessageById(docId);
    aiPrevious = message;
    notifyListeners();
    return aiPrevious;
  }

  Future<String?> sendMessageWithId(
      String userId,
      String docId,
      String userMessage,
      String aiMessage
  ) async {
    final message = await repository.sendAiMessageWithId(
      userId,
      docId,
      userMessage,
      aiMessage,
    );
    await getMessageById(docId);
    clearList();
    return message;
  }

  void clearList() {
    aiReply.clear();
    notifyListeners();
  }
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

}
