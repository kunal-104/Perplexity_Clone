import 'package:flutter/material.dart';
import '../services/chat_store.dart';
import '../models/chat_session.dart';
class ChatHistoryScreen extends StatelessWidget {
  final Function(ChatSession) onChatSelected;

  const ChatHistoryScreen({
    super.key,
    required this.onChatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView.builder(
        itemCount: ChatStore.history.length,
        itemBuilder: (context, index) {
          final chat = ChatStore.history[index];

          return ListTile(
            title: Text(
              chat.title,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context); // ✅ close drawer
              onChatSelected(chat);   // ✅ load chat
            },
          );
        },
      ),
    );
  }
}
