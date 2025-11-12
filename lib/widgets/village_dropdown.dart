import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VillageDropdown extends StatefulWidget {
  final String? selectedValue;
  final String? districtCode;
  final Function(String? value, String? code) onChanged;

  const VillageDropdown({
    super.key,
    this.selectedValue,
    required this.districtCode,
    required this.onChanged,
  });

  @override
  State<VillageDropdown> createState() => _VillageDropdownState();
}

class _VillageDropdownState extends State<VillageDropdown> {
  List<Map<String, dynamic>> _villages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.districtCode != null) {
      _loadVillages(widget.districtCode!);
    }
  }

  @override
  void didUpdateWidget(VillageDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.districtCode != oldWidget.districtCode) {
      if (widget.districtCode != null) {
        _loadVillages(widget.districtCode!);
      } else {
        setState(() {
          _villages = [];
        });
      }
    }
  }

  Future<void> _loadVillages(String districtCode) async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('https://wilayah.id/api/villages/$districtCode.json'),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        setState(() {
          _villages = data
              .map((v) => {'code': v['code'], 'name': v['name']})
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading villages: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Village (Kelurahan/Desa)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) async {
            return _villages
                .map((v) => v['name'] as String)
                .where((v) => v.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          selectedItem: widget.selectedValue,
          enabled: _villages.isNotEmpty && !_isLoading,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search village...",
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
                  ? "Loading villages..."
                  : _villages.isEmpty
                  ? "Select district first"
                  : "Select your village",
              _villages.isNotEmpty && !_isLoading,
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              final code = _villages.firstWhere(
                (v) => v['name'] == value,
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

  InputDecoration _buildInputDecoration(String hint, bool enabled) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: enabled ? Colors.grey : Colors.grey.shade400),
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
