import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

class ChatStore {
  static const String _storageKey = 'chat_history';

  static List<ChatSession> history = [];

  /// 🔹 Load from device
  static Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List decoded = jsonDecode(data);
      history = decoded
          .map((e) => ChatSession.fromJson(e))
          .toList();
    }
  }

  /// 🔹 Save to device
  static Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      history.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  /// 🔹 Add chat
  static Future<void> add(ChatSession chat) async {
    history.insert(0, chat);
    await saveHistory();
  }

  /// 🔹 Delete chat
  static Future<void> delete(ChatSession chat) async {
    history.removeWhere((c) => c.id == chat.id);
    await saveHistory();
  }
}
