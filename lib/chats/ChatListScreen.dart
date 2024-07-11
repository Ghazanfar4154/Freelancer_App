import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/animation.dart';
import '../login_screen/LoginApiHandler.dart';
import 'ChatApiHandler.dart';
import 'ChatScreen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> chats;
  Set<String> processedUserIds = Set<String>();
  late String? userId;
  late AnimationController _controller;
  late Animation<double> _animation;

  void getDetails()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = await prefs.get('userId').toString();
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    getDetails();
    chats = ChatApiHandler.getChats();
    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openChat(String clientId, String otherUserId) async {
    String? chatId = await ChatApiHandler.openOrCreateChat(clientId);
    if (chatId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId, otherUserId: otherUserId)),
      );
    } else {
      print('Failed to open or create chat');
    }
  }

  Future<Map<String, dynamic>?> _fetchUserDetails(String otherUserId) async {

    return await LoginApiHandler.getUserDetailsById(otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.teal, // Change app bar color to cyan
      ),
      body: FutureBuilder<List<dynamic>>(
        future: chats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats found'));
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chat = snapshot.data![index];
                var otherUserId = chat['users'].firstWhere((user) => user['_id'] != userId)['_id'];

                // Check if this user ID has been processed before
                if (processedUserIds.contains(otherUserId)) {
                  return SizedBox.shrink(); // Skip this chat
                }

                processedUserIds.add(otherUserId); // Add the user ID to processed set

                return FutureBuilder<Map<String, dynamic>?>(
                  future: _fetchUserDetails(otherUserId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: CircleAvatar(child: CircularProgressIndicator()),
                        title: Text('Loading...'),
                      );
                    }
                    else if (userSnapshot.hasError || !userSnapshot.hasData) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.error)),
                        title: Text('Error loading user'),
                      );
                    }
                    else {
                      var user = userSnapshot.data!;
                      var imageBytes = base64Decode(user['image']);
                      return ScaleTransition(
                        scale: _animation,
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: MemoryImage(imageBytes),
                            ),
                            title: Text(
                              user['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Tap to chat',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () => _openChat(userId!,otherUserId),
                            trailing: Icon(Icons.chat_bubble, color:Colors.teal),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
