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
    final bool isValidValue = value != null && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6), 
        DropdownButtonFormField<String>(
          value: isValidValue ? value : null,
          validator: validator,
          onChanged: onChanged,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13),
          ),
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
            }).toList();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: _buildBorder(AppColors.border),
            focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red, width: 1.5),
          ),
          items: items.map((String item) {
            final bool isSelected = value == item;
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isSelected 
                          ? Icons.radio_button_checked_rounded 
                          : Icons.radio_button_off_rounded,
                      color: isSelected ? AppColors.primary : AppColors.border,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}