import 'package:flutter/material.dart';
import 'package:agrow/widgets/health_gauge.dart';

class AnalysisResultsPage extends StatelessWidget {
  final String analyzedImageUrl;
  final String detectedDiseaseName;
  final int cropHealthPercentage;

  const AnalysisResultsPage({
    super.key,
    required this.analyzedImageUrl,
    required this.detectedDiseaseName,
    required this.cropHealthPercentage,
  });

  // 🌿 Disease → Recommendations mapping
  List<String> getRecommendations(String disease) {
    const recommendationsMap = {
      "Bell Pepper Bacterial Spot": [
        "Remove infected leaves immediately.",
        "Avoid overhead watering.",
        "Apply copper-based bactericide weekly.",
      ],
      "Bell Pepper Healthy": [
        "Maintain regular watering.",
        "Use organic fertilizer every two weeks.",
        "Monitor for early signs of leaf spots.",
      ],
      "Potato Early Blight": [
        "Remove affected foliage.",
        "Rotate crops yearly.",
        "Apply chlorothalonil-based fungicide.",
      ],
      "Potato Late Blight": [
        "Destroy infected plants immediately.",
        "Avoid excessive humidity in the field.",
        "Use copper-based fungicide to prevent spread.",
      ],
      "Potato Healthy": [
        "Maintain balanced soil moisture.",
        "Ensure proper sunlight exposure.",
        "Monitor weekly for leaf discoloration.",
      ],
      "Tomato Bacterial Spot": [
        "Avoid touching wet foliage.",
        "Use clean seeds or transplants.",
        "Apply copper-based spray preventively.",
      ],
      "Tomato Early Blight": [
        "Prune lower leaves to increase airflow.",
        "Avoid overhead irrigation.",
        "Use a fungicide such as chlorothalonil.",
      ],
      "Tomato Late Blight": [
        "Remove and destroy infected plants.",
        "Do not compost diseased debris.",
        "Use fungicides containing mancozeb or copper.",
      ],
      "Tomato Leaf Mold": [
        "Improve greenhouse ventilation.",
        "Avoid prolonged leaf wetness.",
        "Apply sulfur-based fungicide if needed.",
      ],
      "Tomato Septoria Leaf Spot": [
        "Remove infected leaves immediately.",
        "Avoid watering leaves directly.",
        "Rotate crops every 2–3 years.",
      ],
      "Tomato Spider Mites (Two-Spotted)": [
        "Spray neem oil on affected leaves.",
        "Introduce predatory mites (Phytoseiulus).",
        "Keep humidity high to discourage mites.",
      ],
      "Tomato Target Spot": [
        "Prune crowded foliage for better airflow.",
        "Avoid over-fertilization.",
        "Use preventive fungicide spray.",
      ],
      "Tomato Yellow Leaf Curl Virus": [
        "Remove infected plants.",
        "Control whitefly populations.",
        "Plant resistant tomato varieties.",
      ],
      "Tomato Mosaic Virus": [
        "Avoid handling healthy plants after touching infected ones.",
        "Disinfect garden tools regularly.",
        "Grow TMV-resistant tomato varieties.",
      ],
      "Tomato Healthy": [
        "Continue regular watering and fertilization.",
        "Inspect plants weekly for leaf spots or pests.",
        "Mulch to retain soil moisture.",
      ],
      "Unknown": [
        "Unable to identify disease accurately.",
        "Try retaking a clearer photo in good lighting.",
        "Ensure the crop type is supported by the model.",
      ],
    };

    return recommendationsMap[disease] ??
        ["No specific recommendations available for this condition."];
  }

  String getHealthStatus(int percentage) {
    if (percentage >= 80) return "Good";
    if (percentage >= 50) return "Fair";
    return "Poor";
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = getRecommendations(detectedDiseaseName);

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
            // 📸 Analyzed Image
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

            // 🌱 Detected Disease Info
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
                    "Detected Condition:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detectedDiseaseName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A550),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ❤️ Crop Health Card
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
              child: Row(
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
                          color: Color(0xFF00A550),
                        ),
                      ),
                      Text(
                        getHealthStatus(cropHealthPercentage),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                  CustomHealthGauge(percentage: cropHealthPercentage),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 💡 Recommendations
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
                  ...recommendations.map(
                    (rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF00A550), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(
                                  fontSize: 16, height: 1.5, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🔘 Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A550),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to My Fields!')),
                  );
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst);
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
                onPressed: () => Navigator.of(context).pop(),
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
