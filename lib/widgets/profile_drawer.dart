import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  final Map<String, dynamic>? userProfile;
  final VoidCallback onLogout;

  const ProfileDrawer({super.key, required this.userProfile, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userProfile!['skills'] ?? 'User'),
            accountEmail: Text(userProfile!['email'] ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('Mobile: ${userProfile!['mobile']}'),
          ),
          ListTile(
            title: Text('City: ${userProfile!['city']}'),
          ),
          ListTile(
            title: Text('Education: ${userProfile!['education']}'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
