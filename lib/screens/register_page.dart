import 'package:flutter/material.dart';
import '/widgets/province_dropdown.dart';
import '/widgets/city_dropdown.dart';
import '/widgets/district_dropdown.dart';
import '/widgets/village_dropdown.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Address state
  String? _province, _provinceCode;
  String? _city, _cityCode;
  String? _district, _districtCode;
  String? _village, _villageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Image.asset('/images/agrow_logo.png', height: 40),
                  ),
                  const TextSpan(text: ' with Us!'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Text("Have an account? ", style: TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF00A550),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // First and Last Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "First name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _firstNameController,
                        decoration: _buildInputDecoration("First name"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Last name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _lastNameController,
                        decoration: _buildInputDecoration("Last name"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phone number
            const Text(
              "Phone Number",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration("Enter phone number"),
            ),
            const SizedBox(height: 16),

            // Password
            const Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _buildInputDecoration("Enter password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            const Text(
              "Confirm password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: _buildInputDecoration("Enter password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address Section Header
            const Text(
              "Location",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Province Dropdown
            ProvinceDropdown(
              selectedValue: _province,
              onChanged: (value, code) {
                setState(() {
                  _province = value;
                  _provinceCode = code;
                  // Reset child dropdowns
                  _city = _cityCode = null;
                  _district = _districtCode = null;
                  _village = _villageCode = null;
                });
              },
            ),
            const SizedBox(height: 16),

            // City Dropdown
            CityDropdown(
              selectedValue: _city,
              provinceCode: _provinceCode,
              onChanged: (value, code) {
                setState(() {
                  _city = value;
                  _cityCode = code;
                  // Reset child dropdowns
                  _district = _districtCode = null;
                  _village = _villageCode = null;
                });
              },
            ),
            const SizedBox(height: 16),

            // District Dropdown
            DistrictDropdown(
              selectedValue: _district,
              cityCode: _cityCode,
              onChanged: (value, code) {
                setState(() {
                  _district = value;
                  _districtCode = code;
                  // Reset child dropdown
                  _village = _villageCode = null;
                });
              },
            ),
            const SizedBox(height: 16),

            // Village Dropdown
            VillageDropdown(
              selectedValue: _village,
              districtCode: _districtCode,
              onChanged: (value, code) {
                setState(() {
                  _village = value;
                  _villageCode = code;
                });
              },
            ),
            const SizedBox(height: 20),

            // Display complete address if all selected
            if (_province != null &&
                _city != null &&
                _district != null &&
                _village != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A550).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00A550).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF007C3B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "$_village, $_district, $_city, $_province",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Validate all fields including address
                  if (_province == null ||
                      _city == null ||
                      _district == null ||
                      _village == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please complete your address"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // You can access all the data here:
                  debugPrint('Province: $_province (Code: $_provinceCode)');
                  debugPrint('City: $_city (Code: $_cityCode)');
                  debugPrint('District: $_district (Code: $_districtCode)');
                  debugPrint('Village: $_village (Code: $_villageCode)');

                  Navigator.pushNamed(context, '/otp');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A550),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black38,
                  elevation: 4,
                ),
                child: const Text(
                  "Register",
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

  // Input decoration builder
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00A550)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00A550)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF007C3B), width: 2),
      ),
    );
  }
}
