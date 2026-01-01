import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class AIService {
  static const String _apiKey = "API_KEY_HERE";
  static const String _endpoint =
      "https://api.perplexity.ai/chat/completions";

  static const String systemPrompt = '''
You are an AI assistant modeled after Sherlock Holmes.

Identity:
- You are an intelligent AI assistant.
- You reason logically and observe details carefully.

Behavior rules:
- Reply briefly and precisely.
- Be confident, analytical, and slightly witty.
- Avoid unnecessary words.
- Do not explain obvious things unless asked.
- If unsure, say so plainly.

Style:
- Sharp.
- Intelligent.
- Calm.
- No emojis.
- No fluff.

Your goal is to deliver the most insightful answer in the fewest words.
''';


  static Future<String> askAIWithContext(List<Message> messages) async {
    try {
      // ✅ FILTER empty messages (CRITICAL)
      // final apiMessages = messages
      //     .where((m) => m.text.trim().isNotEmpty)
      //     .map((m) => {
      //           "role": m.isUser ? "user" : "assistant",
      //           "content": m.text,
      //         })
      //     .toList();
      final apiMessages = [
      {
        "role": "system",
        "content": systemPrompt,
      },
      ...messages
          .where((m) => m.text.trim().isNotEmpty)
          .map((m) => {
                "role": m.isUser ? "user" : "assistant",
                "content": m.text,
              }),
    ];


      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "model": "sonar",
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
