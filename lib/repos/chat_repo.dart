
import 'package:dio/dio.dart';
import 'package:logger/logger.dart'; 

import '../models/message_model.dart';

class ChatRepo {
  static final Logger _logger = Logger(); 

  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            "generationConfig": {
              "temperature": 2,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            }
          });
      _logger.i(response.toString());
      if (response.statusCode == 200) {
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }
      return '';
    } catch (e) {
      _logger.e('error: ${e.toString()}');
      return '';
    }
  }
}
