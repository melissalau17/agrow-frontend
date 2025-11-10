import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/agrow_bg.jpg', // your background image path
            fit: BoxFit.cover,
          ),

          // Gradient overlay (optional, for readability)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Content overlay
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isPressed = false;
                    });
                    // TODO: Navigate to next page
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isPressed
                            ? [
                          const Color(0xFF0E8037), // Dark green (pressed)
                          const Color(0xFF056C2F),
                        ]
                            : [
                          const Color(0xFF6FE18A), // Light green (normal)
                          const Color(0xFF3CC766),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
