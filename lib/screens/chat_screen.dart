import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_box.dart';
import '../models/message_model.dart';
import 'chat_history_screen.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      messages.add(Message(text: text, isUser: true));
    });
    _scrollToBottom();

    // Add AI reply after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add(Message(text: "AI reply to: $text", isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 70,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const ChatHistoryScreen(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
        title: const Text(
          "perplexity",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (_, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),
          InputBox(onSend: _sendMessage),
        ],
      ),
    );
  }
}

