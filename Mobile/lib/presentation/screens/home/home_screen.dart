import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../chat_detail/chat_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load conversations and online friends when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchConversations();
      context.read<ChatProvider>().fetchFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TBS', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D4AA0))),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(
                  authProvider.user?.fullAvatarUrl ?? '',
                  width: 40, height: 40, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Online Friends Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ONLINE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: chatProvider.friends.length,
              itemBuilder: (context, index) {
                final friend = chatProvider.friends[index];
                return GestureDetector(
                  onTap: () async {
                    try {
                      final response = await context.read<ChatProvider>().accessConversation(friend.id);
                      if (mounted && response != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(conversation: response),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: Image.network(
                                  friend.fullAvatarUrl,
                                  width: 60, height: 60, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.grey),
                                ),
                              ),
                            ),
                            if (friend.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(friend.name.split(' ').first, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Recent Conversations
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('RECENT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: chatProvider.conversations.length,
                    itemBuilder: (context, index) {
                      final convo = chatProvider.conversations[index];
                      // Sửa lỗi 'No element': Kiểm tra nếu có user khác mình
                      final otherUsers = convo.users.where((u) => u.id != authProvider.user?.id).toList();
                      
                      if (otherUsers.isEmpty) return const SizedBox.shrink();
                      
                      final otherUser = otherUsers.first;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              otherUser.fullAvatarUrl,
                              width: 56, height: 56, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                        ),
                        title: Text(otherUser.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(convo.latestMessage?.content ?? 'No messages yet', maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          convo.latestMessage != null 
                              ? '${convo.latestMessage!.createdAt.hour.toString().padLeft(2, '0')}:${convo.latestMessage!.createdAt.minute.toString().padLeft(2, '0')}'
                              : '', 
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400)
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(conversation: convo),
                            ),
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
