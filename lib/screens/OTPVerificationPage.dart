import 'dart:async';
import 'package:flutter/material.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 180;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _verifyOtp() {
    // You can add your OTP verification logic here
    Navigator.pushReplacementNamed(context, '/success');
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "An OTP has been sent to your email.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Enter the OTP:",
              style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Color(0xFF00A550), width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Color(0xFF00A550), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Resend OTP Timer
            Center(
              child: TextButton(
                onPressed: _secondsRemaining == 0
                    ? () {
                  setState(() {
                    _secondsRemaining = 180;
                    _startTimer();
                  });
                }
                    : null,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF00A550)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    _secondsRemaining == 0
                        ? "Resend OTP"
                        : "Resend OTP in ${_formatTime(_secondsRemaining)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: _secondsRemaining == 0
                          ? const Color(0xFF00A550)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Verify OTP Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A550),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
