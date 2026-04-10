import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/conversation_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/api_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final ConversationModel conversation;
  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      final authProvider = context.read<AuthProvider>();
      
      chatProvider.fetchMessages(widget.conversation.id);
      
      // Khởi tạo Socket và tham gia vào phòng chat
      if (authProvider.user != null) {
        chatProvider.initSocket(authProvider.user!);
        SocketService().joinChat(widget.conversation.id);
      }
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final content = _controller.text;
    _controller.clear();

    try {
      await ApiService().sendMessage(content, widget.conversation.id);
      // Khi gửi xong, Backend sẽ emit qua Socket và ChatProvider sẽ tự bắt được ở hàm onMessageReceived
    } catch (e) {
      print('Send Message Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final authProvider = context.watch<AuthProvider>();
    final otherUser = widget.conversation.users.firstWhere((u) => u.id != authProvider.user?.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(otherUser.avatar)),
                if (otherUser.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white))),
                  )
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherUser.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223289))),
                Text(otherUser.isOnline ? 'ONLINE' : 'OFFLINE', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Color(0xFF3D4AA0)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Color(0xFF3D4AA0)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final msg = chatProvider.messages[index];
                final isMe = msg.senderId == authProvider.user?.id;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF3D4AA0) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.grey), onPressed: () {}),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(24)),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                Container(
                  decoration: const BoxDecoration(color: Color(0xFF3D4AA0), shape: BoxShape.circle),
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _sendMessage),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
