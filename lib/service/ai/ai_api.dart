import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/service/model/ai_chat_model.dart';

class AIbotApiService with ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://openrouter.ai/api/v1/chat"),
  );
  List<AiChatModel> ai_reply = [];

  Future<List<AiChatModel>> getData(String query) async {
    try {
      final response = await _dio.post(
        '/completions',
        data: json.encode({
          "model": "minimax/minimax-m2:free",
          "messages": [
            {"role": "user", "content": query},
          ],
        }),
        options: Options(
          headers: {
            "Authorization":
                "Bearer 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",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        // final result = response.data['choices'][0]['message'];
        final data = AiChatModel(
          role: response.data['choices'][0]['message']['role'],
          reasoning: response.data['choices'][0]['message']['reasoning'],
          refusal: response.data['choices'][0]['message']['refusal'],
          content: response.data['choices'][0]['message']['content'],
        );
        ai_reply.add(data);
        print("------------------------------------------------------"
            "$ai_reply");
      }
    } on DioException catch (e) {
      print(e.error);
    } catch (e) {
      print(e);
    }

    return ai_reply;
  }
}
