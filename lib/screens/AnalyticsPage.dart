import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrow/widgets/crop_dropdown.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String selectedCrop = 'Brown rice, rice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'Field Analytics',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop dropdown
            CropDropdown(
              selectedValue: selectedCrop,
              onChanged: (value) {
                setState(() => selectedCrop = value);
              },
            ),
            const SizedBox(height: 24),

            // Health & Planting date row
            Row(
              children: [
                Expanded(
                  child: _bigCard(
                    title: 'Crop Health',
                    value: 'Good',
                    background: const Color(0xFF007F3F),
                    valueColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _bigCard(
                    title: 'Planting Date',
                    value: DateFormat('dd/MM/yyyy').format(DateTime(2025, 10, 20)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Harvest time
            _bigCard(
              title: 'Harvest time (est)',
              value: '12 weeks',
            ),
            const SizedBox(height: 24),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Basic Characteristics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text('More Details >', style: TextStyle(color: Color(0xFF007F3F), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),

            // 2x2 grid of characteristics
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _miniCard(title: 'Nutrients', value: 'Adequate'),
                _miniCard(title: 'Temperature', value: 'Adequate'),
                _miniCard(title: 'Moisture', value: 'Adequate'),
                _miniCard(title: 'Conductivity', value: 'Adequate'),
              ],
            ),
            const SizedBox(height: 24),

            // Water card placeholder
            _waterCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _bigCard({required String title, required String value, Color background = Colors.white, Color valueColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: valueColor.withOpacity(background == Colors.white ? 0.5 : 1))),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }

  Widget _miniCard({required String title, required String value}) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 22,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Water', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text('Normal Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF007F3F))),
          SizedBox(height: 20),
          Text('Chart Goes Here (Optional Placeholder)', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
