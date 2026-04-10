import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/conversation_model.dart';
import '../chat_detail/chat_detail_screen.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchFriendRequests();
      context.read<ChatProvider>().fetchFriends();
    });
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final response = await ApiService().searchUsers(query);
      if (response.statusCode == 200) {
        setState(() => _searchResults = response.data);
      }
    } catch (e) {
      print('Search Users Error: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _sendRequest(String userId) async {
    try {
      await ApiService().sendFriendRequest(userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend request sent!')));
      setState(() => _searchResults = []);
      _searchController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send request')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      appBar: AppBar(
        title: const Text('Circles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFF223289))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your curated connections.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 24),
              
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchUsers,
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(color: const Color(0xFF3D4AA0), borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.person_add_outlined, color: Colors.white),
                  )
                ],
              ),

              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('SEARCH RESULTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                ..._searchResults.map((user) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['avatar']),
                      onBackgroundImageError: (_, __) {},
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF3D4AA0)),
                      onPressed: () => _sendRequest(user['_id']),
                    ),
                  ),
                )),
              ],

              const SizedBox(height: 32),
              
              // Incoming Requests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('INCOMING REQUESTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  if (chatProvider.friendRequests.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade800, borderRadius: BorderRadius.circular(12)),
                      child: Text('${chatProvider.friendRequests.length} NEW', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                ],
              ),
              const SizedBox(height: 12),
              if (chatProvider.friendRequests.isEmpty)
                const Text('No pending requests.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ...chatProvider.friendRequests.map((req) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 25, backgroundImage: NetworkImage(req.sender.avatar)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(req.sender.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Text('Wants to connect with you', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.check_circle, color: Color(0xFF3D4AA0)), onPressed: () async {
                        await ApiService().respondToFriendRequest(req.id, 'accepted');
                        chatProvider.fetchFriendRequests();
                        chatProvider.fetchFriends();
                      }),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 32),
              const Text('ACTIVE CONNECTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              ...chatProvider.friends.map((friend) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(friend.avatar)),
                title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(friend.isOnline ? 'Online now' : 'Last seen recently', style: TextStyle(color: friend.isOnline ? Colors.green : Colors.grey, fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  try {
                    // Mở hoặc tạo cuộc hội thoại với người này
                    final response = await ApiService().createOrGetConversation(friend.id);
                    if (response.statusCode == 200 || response.statusCode == 201) {
                      final conversation = ConversationModel.fromJson(response.data);
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(conversation: conversation),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to open chat')),
                    );
                  }
                },
              )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
