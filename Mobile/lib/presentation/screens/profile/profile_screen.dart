import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final chatProvider = context.watch<ChatProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TBS', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D4AA0))),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.menu, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar & Name
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF3D4AA0), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(user?.avatar ?? ''),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 20, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'Unknown User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF223289))),
                  const Text('Digital Curator & Design Lead', style: TextStyle(color: Colors.grey)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    child: Text(
                      'Exploring the intersection of human connection and technology.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Text('${chatProvider.friends.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF223289))),
                          const Text('CONNECTIONS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Column(
                        children: [
                          Text('Active', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text('STATUS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            // Preference Shell
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('PREFERENCE SHELL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(Icons.person_outline, 'Account', const Color(0xFFE8EAF6)),
            _buildMenuItem(Icons.lock_outline, 'Privacy', const Color(0xFFF3E5F5)),
            _buildMenuItem(Icons.notifications_none, 'Notifications', const Color(0xFFFFF3E0)),
            _buildMenuItem(Icons.help_outline, 'Help', const Color(0xFFE8F5E9)),

            const SizedBox(height: 32),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => authProvider.logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout Session', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color bgColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
