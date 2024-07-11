import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/login_screen/LoginApiHandler.dart';
import 'ChatApiHandler.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  ChatScreen({required this.chatId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Future<List<dynamic>> messages;
  late Future<Map<String, dynamic>?> otherUserDetails;
  late final String userId;

  @override
  void initState(){
    super.initState();

    messages = ChatApiHandler.getMessages(widget.chatId);
    otherUserDetails = _fetchUserDetails();
  }

  Future<Map<String, dynamic>?> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = await prefs.get('userId').toString();
    return await LoginApiHandler.getUserDetailsById(widget.otherUserId);
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      bool success = await ChatApiHandler.sendMessage(widget.chatId, _messageController.text);
      if (success) {
        setState(() {
          messages = ChatApiHandler.getMessages(widget.chatId);
        });
        _messageController.clear();
      } else {
        print('Failed to send message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>?>(
          future: otherUserDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Text('Loading...'),
                ],
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Chat');
            } else {
              var user = snapshot.data!;
              var imageBytes = base64Decode(user['image']);
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: MemoryImage(imageBytes),
                  ),
                  SizedBox(width: 10),
                  Text(user['username']),
                ],
              );
            }
          },
        ),
        backgroundColor: Colors.teal, // Set app bar color to cyan
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];

                      var isSent = message['sender']['_id'] == userId; // Assuming you have sender's user ID

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSent ? Colors.teal : Colors.grey[300], // Different color for sent and received messages
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['sender']['username'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(message['message']),
                                  SizedBox(height: 4),
                                  Text(
                                    message['timestamp'],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
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
                      hintText: 'Enter message...',
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
