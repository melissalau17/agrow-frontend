import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  DateTime selectedDate = DateTime.now();
  bool isManualMode = true;

  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _soilMoistureController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _soilNController = TextEditingController();
  final TextEditingController _soilPController = TextEditingController();
  final TextEditingController _soilKController = TextEditingController();

  LatLng? selectedCoords;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    // Load current location after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LatLng? current = await getCurrentLocation();
      if (current != null) {
        setState(() {
          selectedCoords = current;
          _locationController.text =
              "${current.latitude.toStringAsFixed(5)}, ${current.longitude.toStringAsFixed(5)}";
        });
        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLng(current));
        }
      }
    });
  }

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, // equivalent to desiredAccuracy
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return LatLng(position.latitude, position.longitude);
  }

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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('dd-MM-yyyy').format(selectedDate),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _modeButton('Automatic', !isManualMode),
                        const SizedBox(width: 8),
                        _modeButton('Manual', isManualMode),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Soil Type & Crop Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Soil Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _textField('', _soilTypeController),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crop name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _textField('Enter crop name', _cropNameController),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // NPK & Soil Moisture
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NPK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _textField('N', _soilNController)),
                          const SizedBox(width: 8),
                          Expanded(child: _textField('P', _soilPController)),
                          const SizedBox(width: 8),
                          Expanded(child: _textField('K', _soilKController)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Soil Moisture',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        'Enter moisture',
                        _soilMoistureController,
                        suffix: '%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Coordinates & Live Location Button
            const Text(
              'Coordinates',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _textField('Enter your location', _locationController),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    LatLng? current = await getCurrentLocation();
                    if (current != null) {
                      setState(() {
                        selectedCoords = current;
                        _locationController.text =
                            "${current.latitude.toStringAsFixed(5)}, ${current.longitude.toStringAsFixed(5)}";
                      });
                      mapController?.animateCamera(
                        CameraUpdate.newLatLng(current),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Unable to get location."),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A550),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Live Location',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Google Map
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.2088, 106.8456),
                    zoom: 11,
                  ),
                  onMapCreated: (controller) => mapController = controller,
                  onTap: (pos) => setState(() => selectedCoords = pos),
                  markers: selectedCoords != null
                      ? {
                          Marker(
                            markerId: const MarkerId('field_location'),
                            position: selectedCoords!,
                            draggable: true,
                            onDragEnd: (newPos) {
                              setState(() {
                                selectedCoords = newPos;
                                _locationController.text =
                                    "${newPos.latitude.toStringAsFixed(5)}, ${newPos.longitude.toStringAsFixed(5)}";
                              });
                            },
                          ),
                        }
                      : {},
                ),
              ),
            ),
            if (selectedCoords != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Lat: ${selectedCoords!.latitude.toStringAsFixed(5)}, "
                  "Lng: ${selectedCoords!.longitude.toStringAsFixed(5)}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            const SizedBox(height: 32),

            // Add Field Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Field added successfully!")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A550),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Add Field',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _modeButton(String text, bool isActive) => ElevatedButton(
    onPressed: () => setState(() => isManualMode = text == 'Manual'),
    style: ElevatedButton.styleFrom(
      backgroundColor: isActive
          ? const Color(0xFF00A550)
          : Colors.grey.shade200,
      foregroundColor: isActive ? Colors.white : Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
    ),
    child: Text(
      text,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.black54,
        fontSize: 14,
      ),
    ),
  );

  Widget _textField(
    String hint,
    TextEditingController controller, {
    String? suffix,
  }) => TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Colors.black87, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF00A550)),
      ),
    ),
  );

  Widget _buildBottomNavBar() => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navBarItem(Icons.home, "Home", true),
            _navBarItem(Icons.bar_chart_outlined, "Analytics", false),
            _navBarItemCamera(),
            _navBarItem(Icons.tune, "Controls", false),
            _navBarItem(Icons.settings_outlined, "Settings", false),
          ],
        ),
      ),
    ),
  );

  Widget _navBarItem(IconData icon, String label, bool isSelected) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: isSelected ? const Color(0xFF00A550) : Colors.black54,
        size: 28,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF00A550) : Colors.black54,
          fontSize: 12,
        ),
      ),
    ],
  );

  Widget _navBarItemCamera() => Container(
    width: 64,
    height: 64,
    decoration: const BoxDecoration(
      color: Color(0xFF00A550),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
  );
}
