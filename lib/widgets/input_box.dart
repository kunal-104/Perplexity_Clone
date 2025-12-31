import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final Function(String) onSend;
  final bool isDisabled; 
  final VoidCallback onNewChat;
// controls send button only

  const InputBox({
    super.key,
    required this.onSend,
    required this.isDisabled,
    required this.onNewChat,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  final Color sendButtonColor = const Color(0xFF2DA7BA).withOpacity(0.88); // turquoise / blue
  final Color micButtonColor = const Color(0xFF2DA7BA).withOpacity(0.88); // same turquoise for mic
  final Color disabledSendColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    if (widget.isDisabled) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // dark background
        borderRadius: BorderRadius.circular(30), // rounded corners
      ),
      child: Row(
        children: [
          // Left + button
          Container(
            width: 38, // 👈 controls button size
             height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF212121),
            ),
            child:IconButton(
  icon: const Icon(Icons.add, color: Colors.white),
  onPressed: widget.onNewChat,
),

          ),
          const SizedBox(width: 6),

          // Left search button
          Container(
            width: 38, // 👈 controls button size
             height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2A2A2A),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                print("Search tapped");
              },
            ),
          ),
          const SizedBox(width: 6),

          // Text input
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Ask anything...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          // Dynamic right button
          Container(
             width: 38, // 👈 controls button size
             height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isTyping ? sendButtonColor : micButtonColor,
            ),
            child: IconButton(
              icon: Icon(
                _isTyping ? Icons.arrow_upward : Icons.mic,
                color: Colors.white,
              ),
              onPressed: _isTyping
                  ? (widget.isDisabled ? null : _sendMessage)
                  : () {
                      print("Mic tapped!");
                    },
            ),
          ),
        ],
      ),
    );
  }
}
