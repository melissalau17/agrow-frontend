import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CropDropdown extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const CropDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CropDropdown> createState() => _CropDropdownState();
}

class _CropDropdownState extends State<CropDropdown> {

  @override
  Widget build(BuildContext context) {
    final crops = ['Brown rice, rice', 'Tomato', 'Chili', 'Corn'];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        value: widget.selectedValue,
        items: crops.map((crop) {
          final isSelected = crop == widget.selectedValue;

          return DropdownMenuItem<String>(
            value: crop,
            child: MouseRegion(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  crop,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF004D40) 
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) => widget.onChanged(value!),

        // Button Appearance
        buttonStyleData: ButtonStyleData(
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF00A550),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 240,
          offset: const Offset(0, -4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        ),

        menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.zero),
      ),
    );
  }
}
