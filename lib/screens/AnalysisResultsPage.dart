import 'package:flutter/material.dart';
import 'package:agrow/widgets/health_gauge.dart';

class AnalysisResultsPage extends StatelessWidget {
  final String analyzedImageUrl;
  final int cropHealthPercentage;
  final List<String> recommendations;

  const AnalysisResultsPage({
    super.key,
    required this.analyzedImageUrl,
    required this.cropHealthPercentage,
    required this.recommendations,
  });

  String getHealthStatus(int percentage) {
    if (percentage >= 80) return "Good";
    if (percentage >= 50) return "Fair";
    return "Poor";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Analyzed Image
            Container(
              width: 150,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  analyzedImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Crop Health Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Crop Health:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$cropHealthPercentage%",
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A550)),
                          ),
                          Text(
                            getHealthStatus(cropHealthPercentage),
                            style: const TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                      CustomHealthGauge(
                          percentage: cropHealthPercentage), // Custom gauge widget
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recommendations Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recommendations:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      rec,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A550), // Green background
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to My Fields!')),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst); // Go back to root
                },
                child: const Text(
                  "Add To My Fields",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Color(0xFF00A550), width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Go back to the camera page to take another photo
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Take Another Photo",
                  style: TextStyle(fontSize: 18, color: Color(0xFF00A550)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}