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
          Image.asset(
            '/images/agrow_bg.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                children: [
                  // Logo and Tagline at the top
                  const SizedBox(height: 60),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      children: [
                        TextSpan(text: 'a'),
                        TextSpan(
                          text: 'Grow',
                          style: TextStyle(color: Color(0xFF6FE18A)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Smart Solution for Farmers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Arrow button at the bottom
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
                      Navigator.pushNamed(context, '/onboarding');
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
                            color: Colors.black.withValues(alpha: 0.2),
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}