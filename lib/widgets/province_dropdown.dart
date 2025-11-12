import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProvinceDropdown extends StatefulWidget {
  final String? selectedValue;
  final Function(String? value, String? code) onChanged;

  const ProvinceDropdown({
    super.key,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  State<ProvinceDropdown> createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  List<Map<String, dynamic>> _provinces = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('https://wilayah.id/api/provinces.json'),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        setState(() {
          _provinces = data
              .map((p) => {'code': p['code'], 'name': p['name']})
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading provinces: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Province", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) async {
            return _provinces
                .map((p) => p['name'] as String)
                .where((p) => p.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          selectedItem: widget.selectedValue,
          enabled: !_isLoading,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search province...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: _buildInputDecoration(
              _isLoading ? "Loading provinces..." : "Select your province",
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              final code = _provinces.firstWhere(
                (p) => p['name'] == value,
              )['code'];
              widget.onChanged(value, code);
            } else {
              widget.onChanged(null, null);
            }
          },
        ),
      ],
    );
  }

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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
