import 'package:flutter/material.dart';
import '../services/chat_store.dart';
import '../models/chat_session.dart';

class ChatHistoryScreen extends StatefulWidget {
  final Function(ChatSession) onChatSelected;

  const ChatHistoryScreen({
    super.key,
    required this.onChatSelected,
  });

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {

  // ✅ DELETE CHAT SAFELY
  Future<void> _deleteChat(ChatSession chat) async {
    await ChatStore.delete(chat);
    setState(() {});
  }


  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()}w';
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Perplexity',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: ChatStore.history.length,
        itemBuilder: (context, index) {
          final chat = ChatStore.history[index];

          return InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.onChatSelected(chat); // 🔥 IMPORTANT
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.lock, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              _timeAgo(chat.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    color: const Color(0xFF1E1E1E),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteChat(chat);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
