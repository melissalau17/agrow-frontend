import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  final TextEditingController _areaController =
  TextEditingController(text: '1.8');
  final TextEditingController _rateController =
  TextEditingController(text: '100');
  final TextEditingController _locationController = TextEditingController();

  String selectedCrop = 'Brown rice, rice';
  DateTime selectedDate = DateTime.now();
  LatLng? selectedCoords;

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Field",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(context),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Field added successfully!"),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A550),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                "Add Field",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem("Date", DateFormat('dd-MM-yyyy').format(selectedDate)),
              _buildInfoItem("Area", "${_areaController.text} Ha"),
            ],
          ),
          const Divider(height: 24, thickness: 1.2),

          // Crop dropdown
          const Text("Crop",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child:
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                value: selectedCrop,
                items: [
                  _buildStyledItem('Brown rice, rice'),
                  _buildStyledItem('Tomato'),
                  _buildStyledItem('Chili'),
                  _buildStyledItem('Corn'),
                ],
                onChanged: (value) {
                  setState(() => selectedCrop = value!);
                },
                buttonStyleData: ButtonStyleData(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A550),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  offset: const Offset(0, -4), // aligns dropdown tightly under the button
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero, // removes default indentation
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Standard Rate
          const Text("Standard rate",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          TextField(
            controller: _rateController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter rate",
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(height: 16),

          // Location Field
          const Text("Location",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: "Enter field location (e.g. Jakarta)",
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(height: 16),

          // Coordinates Map
          const Text("Coordinates",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade300,
            ),
            clipBehavior: Clip.hardEdge,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-6.2088, 106.8456), // Jakarta default
                zoom: 11,
              ),
              onMapCreated: (controller) => mapController = controller,
              onTap: (position) {
                setState(() => selectedCoords = position);
              },
              markers: selectedCoords != null
                  ? {
                Marker(
                    markerId: const MarkerId('field_location'),
                    position: selectedCoords!,
                    infoWindow: const InfoWindow(title: "Field Location"))
              }
                  : {},
            ),
          ),
          if (selectedCoords != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Lat: ${selectedCoords!.latitude.toStringAsFixed(5)}, Lng: ${selectedCoords!.longitude.toStringAsFixed(5)}",
                style: const TextStyle(color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _buildStyledItem(String text) {
    final isSelected = selectedCrop == text;

    return DropdownMenuItem(
      value: text,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB9F6CA) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF00A550),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: "Analytics"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: "Controls"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }
}
