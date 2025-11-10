import 'package:flutter/material.dart';
import 'EditProfilePage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Placeholder user data
  static const String userName = "Pengguna";
  static const String userEmail = "pengguna@agrow.com";

  @override
  Widget build(BuildContext context) {
    // Function to handle navigation to the Edit Profile page
    void navigateToEditProfile() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const EditProfilePage()),
      );
    }

    // Function to handle logout
    void handleLogout() {
      // In a real app, this would clear authentication tokens and navigate
      // back to the welcome/login screen (e.g., using Navigator.pushNamedAndRemoveUntil)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging out... (Simulated)')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents a back button on the main tab
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Top Section: Avatar & Edit Button ---
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey, // Placeholder avatar color
              child: Icon(Icons.person, size: 70, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: navigateToEditProfile,
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A550),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 40),

            // --- Menu Items ---
            _buildMenuItem(
              context,
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () { /* Navigate to Notifications Page */ },
            ),
            _buildMenuItem(
              context,
              icon: Icons.shield_outlined,
              title: 'Privacy & Security',
              onTap: () { /* Navigate to Privacy Page */ },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () { /* Navigate to Help Page */ },
            ),

            const Divider(height: 2, indent: 20, endIndent: 20),

            // Logout Button (Distinctive styling)
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: handleLogout,
              color: Colors.red, // Highlight logout button
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color color = Colors.black87,
      }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}