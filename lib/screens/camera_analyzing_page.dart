import 'package:flutter/material.dart';
import 'analysis_results_page.dart';

class AnalyzingPage extends StatefulWidget {
  final String capturedImageUrl;

  const AnalyzingPage({super.key, required this.capturedImageUrl});

  @override
  State<AnalyzingPage> createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<AnalyzingPage> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    await Future.delayed(const Duration(seconds: 3)); 

    if (mounted) {
      const String detectedDiseaseName = "Tomato Early Blight"; 
      const int healthScore = 87;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AnalysisResultsPage(
            analyzedImageUrl: widget.capturedImageUrl,
            detectedDiseaseName: detectedDiseaseName,
            cropHealthPercentage: healthScore,
          ),
        ),
      );
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  widget.capturedImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A550)),
                strokeWidth: 3,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Analyzing...',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
