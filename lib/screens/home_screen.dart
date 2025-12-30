import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Perplexity Clone'),
    //   ),
    //   body: Center(
    //     child: ElevatedButton(
    //       onPressed: () {
    //         // Navigate to Chat Screen
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => const ChatScreen()),
    //         );
    //       },
    //       child: const Text('Go to Chat'),
    //     ),
    //   ),
    // );
  }
}
