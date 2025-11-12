import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DistrictDropdown extends StatefulWidget {
  final String? selectedValue;
  final String? cityCode;
  final Function(String? value, String? code) onChanged;
  
  const DistrictDropdown({
    super.key,
    this.selectedValue,
    required this.cityCode,
    required this.onChanged,
  });

  @override
  State<DistrictDropdown> createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  List<Map<String, dynamic>> _districts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.cityCode != null) {
      _loadDistricts(widget.cityCode!);
    }
  }

  @override
  void didUpdateWidget(DistrictDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cityCode != oldWidget.cityCode) {
      if (widget.cityCode != null) {
        _loadDistricts(widget.cityCode!);
      } else {
        setState(() {
          _districts = [];
        });
      }
    }
  }

  Future<void> _loadDistricts(String cityCode) async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse('https://wilayah.id/api/districts/$cityCode.json'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        setState(() {
          _districts = data.map((d) => {'code': d['code'], 'name': d['name']}).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading districts: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "District (Kecamatan)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) async {
            return _districts
                .map((d) => d['name'] as String)
                .where((d) => d.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          selectedItem: widget.selectedValue,
          enabled: _districts.isNotEmpty && !_isLoading,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search district...",
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
                ? "Loading districts..." 
                : _districts.isEmpty 
                  ? "Select city first" 
                  : "Select your district",
              _districts.isNotEmpty && !_isLoading,
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              final code = _districts.firstWhere((d) => d['name'] == value)['code'];
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