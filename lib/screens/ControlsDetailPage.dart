import 'package:flutter/material.dart';

class AnalyticsDetailPage extends StatefulWidget {
  const AnalyticsDetailPage({super.key});

  @override
  State<AnalyticsDetailPage> createState() => _AnalyticsDetailPageState();
}

class _AnalyticsDetailPageState extends State<AnalyticsDetailPage> {
  bool waterOn = false; // Will later update from backend / MQTT / Firebase / REST
  int _currentPage = 0; // State variable to track the current page for the indicator

  // Data for the two pages of condition cards
  final List<List<Map<String, dynamic>>> _conditionPages = [
    // Page 1: Plant Conditions
    [
      {"label": "Humidity", "value": "70% RH", "color": Colors.white},
      {"label": "Warmth", "value": "20°C", "color": Colors.white},
      {"label": "Moisture", "value": "40%", "color": Colors.white},
    ],
    // Page 2: Soil Nutrients (based on the image you provided)
    [
      // Nitrogen card is green
      {"label": "Nitrogen", "value": "13%", "color": const Color(0xFF00A550)},
      {"label": "Phosphorus Oxide", "value": "0%", "color": Colors.white},
      {"label": "Potassium", "value": "38%", "color": Colors.white},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Field Zone 1",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Title
          const Text("Plant Conditions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // SCROLLABLE CONDITION CARDS (PageView)
          SizedBox(
            height: 120, // Fixed height required for PageView to work inside ListView
            child: PageView.builder(
              itemCount: _conditionPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final pageData = _conditionPages[pageIndex];
                // Display three cards in a row for each page
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Expanded(child: _ConditionCard(data: pageData[0])),
                      const SizedBox(width: 12),
                      Expanded(child: _ConditionCard(data: pageData[1])),
                      const SizedBox(width: 12),
                      Expanded(child: _ConditionCard(data: pageData[2])),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // PAGE INDICATOR (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_conditionPages.length, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? const Color(0xFF00A550) // Active color: Green accent
                      : Colors.grey.shade400, // Inactive color
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          const Text("Device Control", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Device Control Switch
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Watering the Plant",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                Switch(
                  value: waterOn,
                  onChanged: (val) {
                    setState(() => waterOn = val);
                    // TODO: Send command to IOT backend here
                  },
                  activeColor: const Color(0xFF00A550),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Refactored to accept a Map and dynamically set color
class _ConditionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ConditionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final String label = data["label"];
    final String value = data["value"];
    final Color backgroundColor = data["color"] ?? Colors.white;

    // Set text color to white if the background is the primary green
    final Color textColor = backgroundColor == const Color(0xFF00A550)
        ? Colors.white
        : Colors.black;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}