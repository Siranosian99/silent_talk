import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/chat/model/ai_chat_model.dart';

import '../../../constants/api_consts.dart';

class AIbotApiService with ChangeNotifier {
  final _keys=Keys();
  bool isFinished=true;
  late final Dio _dio = Dio(
    BaseOptions(baseUrl: _keys.baseUrl),
  );
  AIbotApiService(){
    _keys;
  }
  List<AiChatModel> ai_reply = [];

  void isFinihsedChanger(){
    isFinished= !isFinished;
    notifyListeners();
  }
  Future<List<AiChatModel>> getData(String query) async {
    try {
      final response = await _dio.post(
        _keys.endPoint,
        data: json.encode({
          "model":_keys.modelName ,
          "messages": [
            {"role": "user", "content": query},
          ],
        }),
        options: Options(
          headers: {
            "Authorization":
               _keys.apiKey,
            "Content-Type": "application/json",
          },
        ),
      );
      ai_reply.add(AiChatModel(role: 'user', content: query));
      if (response.statusCode == 200) {
        final msg = response.data['choices'][0]['message'];
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
        print("------------------------------------------------------"
            "$ai_reply");
      }
      else {
        debugPrint("Error: ${response.statusMessage}");
      }

    } on DioException catch (e) {
      print(e.error);
    } catch (e) {
      print(e);
    }

    return ai_reply;
  }
}
