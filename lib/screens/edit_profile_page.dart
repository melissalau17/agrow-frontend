import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Placeholder controllers with initial data (simulated from ProfilePage)
  final TextEditingController _nameController = TextEditingController(text: "Pengguna");
  final TextEditingController _emailController = TextEditingController(text: "pengguna@agrow.com");
  final TextEditingController _locationController = TextEditingController(text: "Jakarta, Indonesia");
  final TextEditingController _passwordController = TextEditingController(text: "*********"); // Simulated password field

  void _saveProfile() {
    // In a real app, input validation and backend update would happen here.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully! (Simulated)')),
    );
    Navigator.of(context).pop(); // Go back to Profile Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () { /* Handle avatar change */ },
              icon: const Icon(Icons.photo_camera, size: 18, color: Color(0xFF00A550)),
              label: const Text('Change Photo', style: TextStyle(color: Color(0xFF00A550))),
            ),
            const SizedBox(height: 30),

            // --- Input Fields ---
            _buildInputField('Name', _nameController, Icons.person_outline),
            _buildInputField('Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            _buildInputField('Location', _locationController, Icons.location_on_outlined),
            _buildInputField('Password', _passwordController, Icons.lock_outline, isPassword: true),

            const SizedBox(height: 40),

            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A550),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00A550), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        ),
      ),
    );
  }
}