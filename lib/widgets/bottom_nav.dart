import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        CircleBorder(),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Home
            _buildNavItem(0, Icons.home, "Home"),
            // Analytics
            _buildNavItem(1, Icons.analytics, "Analytics"),

            // Spacer for the FloatingActionButton in the center
            const SizedBox(width: 48),

            // Controls (Index 3, after Camera/FAB which is conceptually Index 2)
            // Using Icons.tune for the controls icon as seen in the image
            _buildNavItem(3, Icons.tune, "Controls"),
            // Settings
            _buildNavItem(4, Icons.settings, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = index == currentIndex;
    final Color color = isSelected ? const Color(0xFF00A550) : Colors.grey.shade700;

    return Expanded(
      child: InkWell(
        onTap: () => onTabTapped(index),
        // Use Padding to separate the elements visually
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: color, size: 28),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Scaffold(
//   bottomNavigationBar: BottomNav(currentIndex: _selectedIndex, onTabTapped: _onItemTapped),
//   floatingActionButton: FloatingActionButton(
//     backgroundColor: const Color(0xFF00A550),
//     shape: const CircleBorder(),
//     onPressed: () => _onItemTapped(2), // Camera is index 2
//     child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
//   ),
//   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//   // ... rest of the Scaffold content
// )