import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CropDropdown extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const CropDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final crops = [
      'Brown rice, rice',
      'Tomato',
      'Chili',
      'Corn',
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: selectedValue,
        items: crops.map((crop) {
          final isSelected = crop == selectedValue;
          return DropdownMenuItem(
            value: crop,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFB9F6CA) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                crop,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) => onChanged(value!),

        // Button Appearance
        buttonStyleData: ButtonStyleData(
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF00A550),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),

        // Dropdown Container Style
        dropdownStyleData: DropdownStyleData(
          maxHeight: 240,
          offset: const Offset(0, -4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
