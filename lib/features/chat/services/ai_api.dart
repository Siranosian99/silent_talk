import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/chat/model/ai_chat_model.dart';

import '../../../constants/api_consts.dart';

class AIbotApiService with ChangeNotifier {
  final _keys = Keys();
  bool isFinished = true;
  late final Dio _dio = Dio(BaseOptions(baseUrl: _keys.baseUrl,
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 60)));

      AIbotApiService()

  {

  _keys

  ;
}

List<AiChatModel> ai_reply = [];

void isFinihsedChanger() {
  isFinished = !isFinished;
  notifyListeners();
}

Future<List<AiChatModel>> getData(String query) async {
  try {
    final response = await _dio.post(
      _keys.endPoint,
      data: {
        "model": _keys.modelName,
        "messages": [
          {"role": "user", "content": query},
        ],
      },

      options: Options(
        headers: {
          "Authorization": _keys.apiKey,
          "Content-Type": "application/json",
        },
      ),
    );
    ai_reply.add(AiChatModel(role: 'assistant', content: query));
    if (response.statusCode == 200) {
      final msg = response.data['choices'][0]['message'];
      print("-------$msg");
      final data = AiChatModel(
        role: msg['role'],
        reasoning: msg['reasoning'],
        refusal: msg['refusal'],
        content: msg['content'],
      );
      ai_reply.add(data);
      notifyListeners();
      isFinihsedChanger();
      debugPrint("✅ AI response added: ${data.content}");
      print(
        "------------------------------------------------------"
            "$ai_reply",
      );
    }
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;

    print("❌ DioException");
    print("Status Code: $statusCode");
    print("Message: ${e.message}");
    print("Response: ${e.response?.data}");

    if (statusCode == 400) {
      debugPrint("❌ 400 - Bad Request");
      debugPrint("The request sent is invalid.");
    } else if (statusCode == 401) {
      debugPrint("❌ 401 - Unauthorized");
      debugPrint("The API Key / Token is invalid or missing.");
    } else if (statusCode == 403) {
      debugPrint("❌ 403 - Forbidden");
      debugPrint("You do not have permission to perform this action.");
    } else if (statusCode == 404) {
      debugPrint("❌ 404 - Not Found");
      debugPrint("The endpoint or requested resource was not found.");
    } else if (statusCode == 405) {
      debugPrint("❌ 405 - Method Not Allowed");
      debugPrint("The HTTP method used is not allowed.");
    } else if (statusCode == 408) {
      debugPrint("❌ 408 - Request Timeout");
      debugPrint("The request timed out.");
    } else if (statusCode == 409) {
      debugPrint("❌ 409 - Conflict");
      debugPrint("The request conflicts with the current state.");
    } else if (statusCode == 422) {
      debugPrint("❌ 422 - Unprocessable Entity");
      debugPrint("The data sent cannot be processed.");
    } else if (statusCode == 429) {
      debugPrint("❌ 429 - Too Many Requests");
      debugPrint("Too many requests were sent. Rate limit exceeded.");
    } else if (statusCode == 500) {
      debugPrint("❌ 500 - Internal Server Error");
      debugPrint("An error occurred on the API server.");
    } else if (statusCode == 502) {
      debugPrint("❌ 502 - Bad Gateway");
      debugPrint("There is a problem with the gateway or proxy.");
    } else if (statusCode == 503) {
      debugPrint("❌ 503 - Service Unavailable");
      debugPrint("The API is currently unavailable.");
    } else if (statusCode == 504) {
      debugPrint("❌ 504 - Gateway Timeout");
      debugPrint("The server did not respond in time.");
    } else {
      debugPrint("❌ Unknown HTTP error: $statusCode");
    }
  } catch (e) {
    debugPrint("❌ Unexpected error: $e");
  }

  return ai_reply;
}}
