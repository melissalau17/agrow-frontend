import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityDropdown extends StatefulWidget {
  final String? selectedValue;
  final String? provinceCode;
  final Function(String? value, String? code) onChanged;
  
  const CityDropdown({
    super.key,
    this.selectedValue,
    required this.provinceCode,
    required this.onChanged,
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  List<Map<String, dynamic>> _cities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.provinceCode != null) {
      _loadCities(widget.provinceCode!);
    }
  }

  @override
  void didUpdateWidget(CityDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provinceCode != oldWidget.provinceCode) {
      if (widget.provinceCode != null) {
        _loadCities(widget.provinceCode!);
      } else {
        setState(() {
          _cities = [];
        });
      }
    }
  }

  Future<void> _loadCities(String provinceCode) async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse('https://wilayah.id/api/regencies/$provinceCode.json'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        setState(() {
          _cities = data.map((c) => {'code': c['code'], 'name': c['name']}).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading cities: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "City / Regency (Kabupaten/Kota)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) async {
            return _cities
                .map((c) => c['name'] as String)
                .where((c) => c.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          selectedItem: widget.selectedValue,
          enabled: _cities.isNotEmpty && !_isLoading,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search city...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: _buildInputDecoration(
              _isLoading 
                ? "Loading cities..." 
                : _cities.isEmpty 
                  ? "Select province first" 
                  : "Select your city",
              _cities.isNotEmpty && !_isLoading,
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              final code = _cities.firstWhere((c) => c['name'] == value)['code'];
              widget.onChanged(value, code);
            } else {
              widget.onChanged(null, null);
            }
          },
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint, bool enabled) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: enabled ? Colors.grey : Colors.grey.shade400,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabled ? const Color(0xFF00A550) : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabled ? const Color(0xFF00A550) : Colors.grey.shade300,
        ),
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