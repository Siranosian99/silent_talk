import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/chat/model/ai_message_model.dart';

import '../../../constants/api_consts.dart';
import '../../user/repository/authenticator_repository.dart';
import '../model/ai_response_model.dart';
import '../model/chat_model.dart';
import '../../user/service/authenticator.dart';


class AiBackend {
  final AuthenticatorRepository _authenticator =AuthenticatorRepository(AuthenticatorService());
  final _keys = Keys();
  // String? conversationId;
  String? chatId;
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _keys.baseUrl,
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 60),
    ),
  );

  Future<List<AiResponseModel>> getData(String query) async {
    const int maxRetry = 1;

    for (int i = 0; i < maxRetry; i++) {
      final delay = Duration(seconds: 1 * (1 << i));

      try {
        final response = await _dio.post(
          _keys.endPoint,
          data: {
            "model": _keys.modelName,
            "messages": [
              {
                "role": "user",
                "content": query,
              },
            ],
          },
          options: Options(
            headers: {
              "Authorization": _keys.apiKey,
              "Content-Type": "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          final msg = response.data['choices'][0]['message'];

          final userMessage = AiResponseModel(
            role: 'user',
            content: query,
          );

          final aiMessage = AiResponseModel(
            role: msg['role'],
            reasoning: msg['reasoning'],
            refusal: msg['refusal'],
            content: msg['content'],
          );

          debugPrint("AI response added: ${aiMessage.content}");

          return [
            userMessage,
            aiMessage,
          ];
        }

        throw Exception(
          "Unexpected status code: ${response.statusCode}",
        );
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;

        debugPrint("DioException");
        debugPrint("Status Code: $statusCode");
        debugPrint("Message: ${e.message}");
        debugPrint("Response: ${e.response?.data}");

        final bool shouldRetry =
            e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionError ||
                statusCode == 500 ||
                statusCode == 502 ||
                statusCode == 503 ||
                statusCode == 504;

        if (!shouldRetry || i == maxRetry - 1) {
          throw Exception(_getErrorMessage(e));
        }

        await Future.delayed(delay);
      } catch (e) {
        debugPrint("Unexpected error: $e");
        throw Exception("Something went wrong.");
      }
    }

    throw Exception("Something went wrong.");
  }

  String _getErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionError) {
      return "No internet connection. Please check your network.";
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return "Unable to connect to the server.";
    }

    if (e.type == DioExceptionType.sendTimeout) {
      return "The request could not be sent. Please try again.";
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return "The server took too long to respond.";
    }

    switch (statusCode) {
      case 400:
        return "Bad request.";
      case 401:
        return "Token is invalid or missing.";
      case 403:
        return "You do not have permission to perform this action.";
      case 404:
        return "The endpoint or requested resource was not found.";
      case 405:
        return "The HTTP method used is not allowed.";
      case 408:
        return "The request timed out.";
      case 409:
        return "The request conflicts with the current state.";
      case 422:
        return "The data sent cannot be processed.";
      case 429:
        return "Too many requests were sent. Rate limit exceeded.";
      case 500:
        return "An error occurred on the API server.";
      case 502:
        return "There is a problem with the gateway or proxy.";
      case 503:
        return "The API is currently unavailable.";
      case 504:
        return "The server did not respond in time.";
      default:
        return "Something went wrong.";
    }
  }  Future<String?> sendAiMessage(
    String aiMessage,
    String uId1,
    String userMessage,
    // MessageModel message,
  ) async {
    try {
      // conversationId ??=
      //     FirebaseFirestore.instance.collection('ai_chats').doc().id;
      chatId ??= '${uId1}_${DateTime.now().millisecondsSinceEpoch}';
      final chatsCollection = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId);
      final messageDoc = chatsCollection.collection('messages');
      //
      // final docRef = messageDoc.doc();
      await chatsCollection.set({
        "userId": _authenticator.getUserId(),
        "id": chatId,
        "title": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await messageDoc.add({
        "role": 'user',
        "text": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await messageDoc.add({
        "role": 'assistant',
        "text": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await chatsCollection.update({'updatedAt': FieldValue.serverTimestamp()});
      print("save");
      return chatId;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }
  Future<String?> sendAiMessageWithId(
      String aiMessage,
      String uId1,
      String userMessage,
      String chatId
      // MessageModel message,
      ) async {
    try {
      // conversationId ??=
      //     FirebaseFirestore.instance.collection('ai_chats').doc().id;
      final chatsCollection = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId);
      final messageDoc = chatsCollection.collection('messages');
      //
      // final docRef = messageDoc.doc();
      await chatsCollection.set({
        "userId": _authenticator.getUserId(),
        "id": chatId,
        "title": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await messageDoc.add({
        "role": 'user',
        "text": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await messageDoc.add({
        "role": 'assistant',
        "text": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await chatsCollection.update({'updatedAt': FieldValue.serverTimestamp()});
      print("save");
      return chatId;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }
  Future<List<ChatModel>> getMessagesById(String userId) async {
    try {
      List<ChatModel> allData = [];
      final chats = FirebaseFirestore.instance
          .collection('ai_chats')
          .where("userId", isEqualTo: userId);
      QuerySnapshot snapshot = await chats.get();

      for (var doc in snapshot.docs) {
        final data =
        await doc.reference
            .collection('messages')
            .orderBy('createdAt')
            .get();
        final message =
        data.docs.map((messageDoc) {
          final messageData = messageDoc.data();

          return MessageModel(
            role: messageData['role'],
            text: messageData['text'],
            createdAt: (messageData['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        allData.add(ChatModel( userId: doc['userId'],
          id: doc['id'],
          title: doc['title'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
          messages: message,)

        );

      }
      return allData;
    } catch (e, stackTrace) {
      print('ERROR getMessageById: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<List<ChatModel>> getMessageById(String docId) async {
    try {
      List<ChatModel> allData = [];
      final chats = FirebaseFirestore.instance
          .collection('ai_chats')
          .where("id", isEqualTo: docId);
      QuerySnapshot snapshot = await chats.get();

      for (var doc in snapshot.docs) {
        final data =
        await doc.reference
            .collection('messages')
            .orderBy('createdAt')
            .get();
        final message =
        data.docs.map((messageDoc) {
          final messageData = messageDoc.data();

          return MessageModel(
            role: messageData['role'],
            text: messageData['text'],
            createdAt: (messageData['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        allData.add(ChatModel( userId: doc['userId'],
          id: doc['id'],
          title: doc['title'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
          messages: message,)

        );

      }
      return allData;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }


}

//Collection all Data of ai_chats after that we called all ai_chats that include userId
// becuase the messages are new document not inside the ai_chats so we call the messages document which include userId
//