import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.warning;
        icon = Icons.warning;
        break;
      case ToastType.info:
        backgroundColor = AppColors.primary;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
