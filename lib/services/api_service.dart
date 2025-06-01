import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'YOUR_CLOUD_RUN_URL'; // We'll configure this later
  final String _userId;

  ApiService(this._userId);

  Future<String> getChatResponse(String message, Map<String, dynamic> context) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_userId', // We'll implement proper auth tokens
        },
        body: jsonEncode({
          'message': message,
          'context': context,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        throw ApiException('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}