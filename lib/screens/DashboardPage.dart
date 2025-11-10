import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import necessary local components and pages for navigation
import '/widgets/bottom_nav.dart';
import 'MyFields.dart';
import 'CameraPage.dart';
import 'ControlsDetailPage.dart';
import 'AddFieldPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Index 2 is reserved for the FloatingActionButton (Camera)
  int _selectedIndex = 0; // 0: Home, 1: Analytics, 3: Controls, 4: Settings

  // --- Tab Tapping Logic ---
  void _onItemTapped(int index) {
    // If the camera button (index 2) is tapped, navigate to the CameraPage route
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CameraPage()),
      );
      return;
    }

    // For all other tabs, update the selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- Widget Builders for Home Content ---

  // Home Screen Content Builder (The rich UI provided by the user)
  Widget _buildHomeContent(BuildContext context) {
    final currentDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    // Navigation actions specific to the Home Content
    void seeAllFields() => _onItemTapped(3); // Switch to Controls/My Fields tab

    void navigateToAddFieldPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AddFieldPage()),
      );
    }

    void navigateToAnalyticsDetail() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AnalyticsDetailPage()),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF00A550),
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Greeting
            const Text(
              "Good morning, User",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Color(0xFF00A550),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            // Weather Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD9F7E6), Color(0xFFB8F0D1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: Colors.black54),
                      SizedBox(width: 6),
                      Text("Jakarta, Indonesia",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "High: 33°C   Low: 26°C",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        children: [
                          Text("🌡️", style: TextStyle(fontSize: 24)),
                          Text("30°C", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Soil Temp", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("💧", style: TextStyle(fontSize: 24)),
                          Text("85%", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Humidity", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("🌬️", style: TextStyle(fontSize: 24)),
                          Text("5 km/h", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Wind", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("🌧️", style: TextStyle(fontSize: 24)),
                          Text("55%", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Precip.", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // My Fields Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My Fields:",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: seeAllFields, // Switch to Controls Tab (index 3)
                  child: const Text("See All",
                      style: TextStyle(
                          color: Color(0xFF00A550),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFieldCard(
                    status: "Good",
                    image: "https://i.ibb.co/nkY6v5k/chili-field.jpg",
                    name: "Chili Field",
                    size: "1.2 Ha",
                    onTap: navigateToAnalyticsDetail, // Navigates to detail page
                  ),
                  const SizedBox(width: 12),
                  _buildFieldCard(
                    status: "Need Water",
                    image: "https://i.ibb.co/tm6jsQp/tomato-field.jpg",
                    name: "Tomato Field",
                    size: "1.5 Ha",
                    onTap: navigateToAnalyticsDetail, // Navigates to detail page
                  ),
                  const SizedBox(width: 12),
                  _addCard("Add field", navigateToAddFieldPage), // Navigates to AddFieldPage
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI Recommendation Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00A550),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb_outline,
                      color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Check out our AI recommendation for your fields!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // My Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("My Tasks:",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("See All",
                    style: TextStyle(
                        color: Color(0xFF00A550),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTaskCard("7:30 AM", "Water Chili Field", "On Progress",
                      const Color(0xFF00A550)),
                  const SizedBox(width: 12),
                  _buildTaskCard("8:30 AM", "Water Tomato Field", "Not Started",
                      const Color(0xFFA9E9C4)),
                  const SizedBox(width: 12),
                  _addCard("Add task", () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Add Task')),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildFieldCard({
    required String status,
    required String image,
    required String name,
    required String size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(image,
                      height: 100, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A550),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(size, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF00A550),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addCard(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 28, color: Colors.black54),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
      String time, String title, String status, Color statusColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time,
              style: const TextStyle(
                  color: Color(0xFF00A550),
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 4),
          Text(title,
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- Main Widget Options List ---

  late final List<Widget> _widgetOptions = <Widget>[
    // 0: Home Content
    _buildHomeContent(context),
    // 1: Analytics
    const Center(child: Text('Analytics Dashboard Content (Full Page)', style: TextStyle(fontSize: 24, color: Colors.grey))),
    // 2: Camera (Placeholder - navigation handled separately)
    const SizedBox.shrink(),
    // 3: Controls (My Fields Page)
    const ControlsPage(),
    // 4: Settings
    const Center(child: Text('Settings Content', style: TextStyle(fontSize: 24, color: Colors.grey))),
  ];

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the content of the selected tab
      backgroundColor: const Color(0xFFF9FFF8),
      body: _widgetOptions.elementAt(_selectedIndex),

      // Floating Action Button (The raised camera button)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A550),
        shape: const CircleBorder(),
        elevation: 8, // Add elevation for the raised effect
        onPressed: () => _onItemTapped(2), // Camera is index 2
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
      ),

      // Positioning the FAB to be docked in the center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Custom Bottom Navigation Bar (BottomAppBar structure)
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTabTapped: _onItemTapped,
      ),
    );
  }
}