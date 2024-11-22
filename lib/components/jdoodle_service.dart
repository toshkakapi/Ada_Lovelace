// components/jdoodle_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class JDoodleService {
  final String _clientId = '80915a2db35a1eb962e96e195e47dd34'; // Замените на ваш clientId
  final String _clientSecret = '355e60ce76ef24984118ca28756c7b178cc4ac9999509578bbec34fa57401cba'; // Замените на ваш clientSecret
  final String _endpoint = 'https://api.jdoodle.com/v1/execute'; // URL API JDoodle

  // Метод для выполнения кода
  Future<Map<String, dynamic>> executeCode({
    required String script,
    required String language,
    required String versionIndex,
    Map<String, String>? stdinInput,
  }) async {
    Map<String, dynamic> body = {
      'clientId': _clientId,
      'clientSecret': _clientSecret,
      'script': script,
      'language': language,
      'versionIndex': versionIndex,
    };

    if (stdinInput != null && stdinInput.isNotEmpty) {
      body['stdin'] = stdinInput['stdin'];
    }

    try {
      print('Тело запроса: ${jsonEncode(body)}');
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Ответ от JDoodle: ${response.body}'); // Печать ответа

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка выполнения кода: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Ошибка при подключении к JDoodle: $e');
      throw Exception('Ошибка при подключении к JDoodle: $e');
    }

  }
}
