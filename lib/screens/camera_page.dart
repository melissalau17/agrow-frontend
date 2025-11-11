import 'package:flutter/material.dart';
import 'camera_analyzing_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // We'll use a static image to simulate the camera feed for demonstration
  final String _cameraFeedImageUrl = 'https://placehold.co/600x1200/D4F1C5/000000?text=Camera+Preview';
  // For the actual project, you would use a camera controller:
  // CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // In a real app, you'd initialize the camera here
    // For now, we'll just simulate a slight delay
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // Camera is "ready"
    });
  }

  @override
  void dispose() {
    // _cameraController?.dispose(); // Dispose camera controller in a real app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for camera
      body: Stack(
        children: [
          // Simulated Camera Preview (Background Image)
          Positioned.fill(
            child: Image.network(
              _cameraFeedImageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Scanner Overlay (from Image 1)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00A550), width: 2.5),
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar with Camera Controls (Image 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.grey, size: 30),
                    onPressed: () {
                      // Handle gallery access
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Open Gallery')),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      // Simulate capturing the image and navigating to analyzing page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AnalyzingPage(
                            capturedImageUrl: 'https://placehold.co/600x1200/D4F1C5/000000?text=Captured+Plant', // Pass a static image for analysis
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00A550),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner, // Icon for scan/capture
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flashlight_on, color: Colors.grey, size: 30),
                    onPressed: () {
                      // Handle flash toggle
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Toggle Flash')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}