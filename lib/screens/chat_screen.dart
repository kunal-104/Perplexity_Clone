import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_box.dart';
import '../models/message_model.dart';
import 'chat_history_screen.dart';
import 'dart:async';
import '../services/api_service.dart';
import 'dart:math';
import '../models/chat_session.dart';
import '../services/chat_store.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  ChatSession? _currentChat;
  bool _isGenerating = false;

  final ScrollController _scrollController = ScrollController();
    void _startNewChat() {
    setState(() {
      messages.clear();
      _currentChat = null;
    });
  }
  
  void _loadChatFromHistory(ChatSession chat) {
    setState(() {
      _currentChat = chat;
      messages = List.from(chat.messages);
    });
  }

  Future<void> _persistCurrentChat() async {
  if (_currentChat == null) return;

  _currentChat!.messages
    ..clear()
    ..addAll(messages);

  if (!ChatStore.history.any((c) => c.id == _currentChat!.id)) {
    await ChatStore.add(_currentChat!);
  } else {
    await ChatStore.saveHistory();
  }
}


void _sendMessage(String text) async {
  if (text.trim().isEmpty || _isGenerating) return;

  setState(() {
    _isGenerating = true;
    messages.add(Message(text: text, isUser: true));

    // 🆕 Create chat session on first message
    _currentChat ??= ChatSession(
      id: Random().nextInt(999999).toString(),
      title: text.length > 30 ? text.substring(0, 30) : text,
      messages: [],
      createdAt: DateTime.now(),
    );
  });

  final aiReply = await AIService.askAIWithContext(messages);

  final aiMessage = Message(text: "", isUser: false);
  setState(() {
    messages.add(aiMessage);
  });

  int index = 0;
  Timer.periodic(const Duration(milliseconds: 25), (timer) {
    if (index < aiReply.length) {
      setState(() {
        aiMessage.text += aiReply[index];
      });
      index++;
    } else {
      timer.cancel();

     _persistCurrentChat();

      setState(() {
        _isGenerating = false;
      });
    }
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
          drawer: ChatHistoryScreen(
      onChatSelected: _loadChatFromHistory,
    ),

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
         InputBox(
  onSend: _sendMessage,
  isDisabled: _isGenerating,
  onNewChat: _startNewChat,
),


        ],
      ),
    );
  }
}

