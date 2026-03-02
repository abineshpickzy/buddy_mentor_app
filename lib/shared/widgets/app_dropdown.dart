import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final String? Function(String?)? validator;
  final void Function(String?) onChanged;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Recommendation: Ensure 'value' exists in 'items' to prevent crashes
    final bool isValidValue = value != null && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8), // Increased spacing for better tap clarity
        DropdownButtonFormField<String>(
          value: isValidValue ? value : null,
          validator: validator,
          onChanged: onChanged,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
          // Improvement: Customize the dropdown menu appearance
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded, // Rounded icons look more modern
            color: AppColors.textLight,
            size: 22,
          ),
          // Improvement: Style the text inside the menu items
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              );
            }).toList();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            // Reusable border style helper
            enabledBorder: _buildBorder(AppColors.border),
            focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red, width: 1.5),
          ),
          // Recommendation: Map items with unique keys to optimize rebuilds
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDark,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method to keep code clean
  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
