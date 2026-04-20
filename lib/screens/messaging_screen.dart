// lib/screens/messaging_screen.dart
import 'package:flutter/material.dart';
import '../models/message.dart';

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            sender: 'YourUsername', // Replace with actual username
            content: _messageController.text,
            timestamp: DateTime.now(),
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].sender),
                  subtitle: Text(_messages[index].content),
                  trailing: Text(
                    '${_messages[index].timestamp.hour}:${_messages[index].timestamp.minute}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
