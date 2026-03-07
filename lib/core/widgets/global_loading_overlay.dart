import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/global_loading_provider.dart';
import '../constants/app_colors.dart';

class GlobalLoadingOverlay extends ConsumerWidget {
  final Widget child;
  
  const GlobalLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingProvider);
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blinking logo animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.3, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 400),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 60,
                          width: 60,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Loading indicator
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}