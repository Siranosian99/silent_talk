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
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      final response = await repository.getData(query);
      aiReply.addAll(response);
      // aiReply.add(
      //   AiResponseModel(
      //     role: 'user',
      //     content: query,
      //   ),
      // );
      return aiReply;
    } catch (e) {
      errorMessage = e.toString();
      print("error send to AI api ${e.toString()}");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
    print("--------- aiPrevious is here:$aiPrevious");
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
    print("list cleared:$aiReply");
    notifyListeners();
  }
  // Future<List<AiChatModel>> getDataWithId(AiChatModel chat) async {
  //   isLoading = true;
  //   notifyListeners();
  //   int maxRetry = 5;
  //   for (int i = 0; i < maxRetry; i++) {
  //     final delay = Duration(seconds: 1 * (1 << i));
  //     try {
  //       // isLoading = true;
  //       // notifyListeners();
  //       final response = await _dio.post(
  //         _keys.endPoint,
  //         data: {
  //           "model": _keys.modelName,
  //           "messages": [
  //             {"role": "user", "content": query},
  //           ],
  //         },
  //
  //         options: Options(
  //           headers: {
  //             "Authorization": _keys.apiKey,
  //             "Content-Type": "application/json",
  //           },
  //         ),
  //       );
  //
  //       notifyListeners();
  //       aiReply.add(AiChatModel(role: 'user', content: query));
  //       if (response.statusCode == 200) {
  //         isLoading = false;
  //         final msg = response.data['choices'][0]['message'];
  //         print("-------$msg");
  //         final data = AiChatModel(
  //           role: msg['role'],
  //           reasoning: msg['reasoning'],
  //           refusal: msg['refusal'],
  //           content: msg['content'],
  //         );
  //         aiReply.add(data);
  //
  //         notifyListeners();
  //         debugPrint("✅ AI response added: ${data.content}");
  //         print(
  //           "------------------------------------------------------"
  //               "$aiReply",
  //         );
  //       }
  //     } on DioException catch (e) {
  //       final statusCode = e.response?.statusCode;
  //
  //       final bool shouldRetry =
  //           e.type == DioExceptionType.connectionTimeout ||
  //               e.type == DioExceptionType.sendTimeout ||
  //               e.type == DioExceptionType.receiveTimeout ||
  //               e.type == DioExceptionType.connectionError ||
  //               statusCode == 500 ||
  //               statusCode == 502 ||
  //               statusCode == 503 ||
  //               statusCode == 504;
  //       print("❌ DioException");
  //       print("Status Code: $statusCode");
  //       print("Message: ${e.message}");
  //       print("Response: ${e.response?.data}");
  //       if (e.type == DioExceptionType.connectionError) {
  //         errorMessage = "No internet connection. Please check your network.";
  //       } else if (e.type == DioExceptionType.connectionTimeout) {
  //         errorMessage = "Unable to connect to the server.";
  //       } else if (e.type == DioExceptionType.sendTimeout) {
  //         errorMessage = "The request could not be sent. Please try again.";
  //       } else if (e.type == DioExceptionType.receiveTimeout) {
  //         errorMessage = "The server took too long to respond.";
  //       }
  //       if(statusCode != null){
  //         if (statusCode == 400) {
  //           debugPrint("❌ 400 - Bad Request");
  //           errorMessage = "Too many requests were sent. Rate limit exceeded";
  //           debugPrint("The request sent is invalid.");
  //           break;
  //         } else if (statusCode == 401) {
  //           debugPrint("❌ 401 - Unauthorized");
  //           errorMessage = " Token is invalid or missing.";
  //           debugPrint("The API Key / Token is invalid or missing.");
  //           break;
  //         } else if (statusCode == 403) {
  //           debugPrint("❌ 403 - Forbidden");
  //           errorMessage = "You do not have permission to perform this action.";
  //           debugPrint("You do not have permission to perform this action.");
  //           break;
  //         } else if (statusCode == 404) {
  //           debugPrint("❌ 404 - Not Found");
  //           debugPrint("The endpoint or requested resource was not found.");
  //           break;
  //         } else if (statusCode == 405) {
  //           debugPrint("❌ 405 - Method Not Allowed");
  //           debugPrint("The HTTP method used is not allowed.");
  //           break;
  //         } else if (statusCode == 408) {
  //           debugPrint("❌ 408 - Request Timeout");
  //           errorMessage = "The request timed out.";
  //           debugPrint("The request timed out.");
  //           break;
  //         } else if (statusCode == 409) {
  //           debugPrint("❌ 409 - Conflict");
  //           debugPrint("The request conflicts with the current state.");
  //           break;
  //         } else if (statusCode == 422) {
  //           debugPrint("❌ 422 - Unprocessable Entity");
  //           debugPrint("The data sent cannot be processed.");
  //           errorMessage = "The data sent cannot be processed.";
  //           break;
  //         } else if (statusCode == 429) {
  //           errorMessage = "Too many requests were sent. Rate limit exceeded";
  //           debugPrint("❌ 429 - Too Many Requests");
  //           errorMessage = "Too many requests were sent. Rate limit exceeded.";
  //           debugPrint("Too many requests were sent. Rate limit exceeded.");
  //           break;
  //         } else if (statusCode == 500) {
  //           debugPrint("❌ 500 - Internal Server Error");
  //           debugPrint("An error occurred on the API server.");
  //         } else if (statusCode == 502) {
  //           debugPrint("❌ 502 - Bad Gateway");
  //           debugPrint("There is a problem with the gateway or proxy.");
  //           errorMessage = "There is a problem with the gateway or proxy.";
  //         } else if (statusCode == 503) {
  //           debugPrint("❌ 503 - Service Unavailable");
  //           debugPrint("The API is currently unavailable.");
  //         } else if (statusCode == 504) {
  //           debugPrint("❌ 504 - Gateway Timeout");
  //           debugPrint("The server did not respond in time.");
  //           errorMessage = "The server did not respond in time.";
  //         } else {
  //           debugPrint("❌ Unknown HTTP error: $statusCode");
  //           errorMessage = "Something went wrong.";
  //           break;
  //         }}
  //       if (!shouldRetry) {
  //         break;
  //       }
  //       await Future.delayed(delay);
  //     } catch (e) {
  //       debugPrint("❌ Unexpected error: $e");
  //     } finally {
  //       isLoading = false;
  //       notifyListeners();
  //     }
  //   }
  //   return aiReply;
  // }

  // Future<List<AiChatModel>> getData(String query) async {
  //   isLoading = true;
  //   errorMessage = '';
  //   notifyListeners();
  //
  //   // Kullanıcı mesajı
  //   aiReply.add(
  //     AiChatModel(
  //       role: 'user',
  //       content: query,
  //     ),
  //   );
  //   notifyListeners();
  //
  //   // AI biraz bekliyormuş gibi davran
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   // Fake AI cevabı
  //   final fakeData = AiChatModel(
  //     role: 'model',
  //     reasoning: "I analyzed the user's question.",
  //     refusal: null,
  //     content: "Hello! How can I help you?",
  //   );
  //
  //   aiReply.add(fakeData);
  //
  //   // Loading bitti
  //   isLoading = false;
  //   notifyListeners();
  //
  //   return aiReply;
  // }
}
