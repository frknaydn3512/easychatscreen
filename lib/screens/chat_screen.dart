import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  final _scrollController = ScrollController();


  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_enteredMessage.trim().isEmpty || user == null) return;


    final userData = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'email': user.email,
      'userImage': userData['image_url']
    });

    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });

    _scrollController.animateTo(
  0.0,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOut,
);

  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('chat')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final data = chatDocs[index];
                    final user = FirebaseAuth.instance.currentUser;
                    final isMe = user != null && user.uid == data['userId'];
                    

                    return MessageBubble(
                      message: data['text'],
                      email: data['email'],
                      isMe: isMe,
                      timestamp: (data['createdAt'] as Timestamp).toDate(),
                      userImage: data['userImage'] ?? 'https://i.pravatar.cc/300',

                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Mesaj yaz...',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
