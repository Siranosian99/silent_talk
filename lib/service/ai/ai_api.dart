import 'dart:convert';

import 'package:dio/dio.dart';

class AIbotApiService{
  final Dio _dio =Dio(BaseOptions(baseUrl: "https://openrouter.ai/api/v1/chat"));

  Future<void>getData(String query)async{
    try {
    final result=await _dio.post('/completions',  data:json.encode({
      "model": "minimax/minimax-m2:free",
      "messages": [
        {
          "role": "user",
          "content": query,
        }
      ],

    }) ,
    options: Options( headers: {
      "Authorization": "Bearer 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",
      "Content-Type": "application/json",
      } ));

    if (result.statusCode == 200) {
      final response=result.data['choices'];
      print(response);

    }
    } on DioException catch (e) {
      print(e.error);
    } catch (e) {
      print(e);
    }
}}