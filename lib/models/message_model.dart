class Message {
  String text;
  final bool isUser;

  Message({
    required this.text,
    required this.isUser,
  });

  // 🔹 Message → JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
    };
  }

  // 🔹 JSON → Message
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
    );
  }
}
