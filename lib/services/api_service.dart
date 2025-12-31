<<<<<<< HEAD
=======
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class AIService {
  static const String _apiKey = "YOUR-API-KEY";
  static const String _endpoint =
      "https://api.perplexity.ai/chat/completions";

  static Future<String> askAIWithContext(List<Message> messages) async {
    try {
      // ✅ FILTER empty messages (CRITICAL)
      final apiMessages = messages
          .where((m) => m.text.trim().isNotEmpty)
          .map((m) => {
                "role": m.isUser ? "user" : "assistant",
                "content": m.text,
              })
          .toList();

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "model": "sonar-pro",
          "messages": apiMessages,
          "max_tokens": 512,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        // 🔍 SHOW REAL ERROR
        return "AI Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
>>>>>>> 25d0ce2 (implemented history and improve the input box design)
