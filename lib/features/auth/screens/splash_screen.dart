import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/utils/app_preferences.dart';
import '../../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Future(() => _navigate());
  }

  void _navigate() async {
    try {
      // Wait for minimum splash time first
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // Then do the heavy operations
      final authFuture = ref.read(authControllerProvider.notifier).initializeAuth();
      final onboardingFuture = AppPreferences.isOnboardingCompleted();
      
      // Wait for both to complete
      final results = await Future.wait([authFuture, onboardingFuture]);
      final completed = results[1] as bool;

      if (mounted) {
        final authState = ref.read(authControllerProvider);
        
        if (authState.isAuthenticated) {
          final userType = authState.user?.userType ?? 1;
          String dashboardRoute;
          switch (userType) {
            case 1:
              dashboardRoute = '/menteedashboard';
              break;
            case 2:
              dashboardRoute = '/mentordashboard';
              break;
            case 3:
              dashboardRoute = '/institutiondashboard';
              break;
            case 4:
              dashboardRoute = '/industrydashboard';
              break;
            default:
              dashboardRoute = '/menteedashboard';
          }
          context.go(dashboardRoute);
        } else if (completed) {
          context.go('/role');
        } else {
          context.go('/onboarding');
        }
      }
    } catch (e) {
      print('Splash navigation error: $e');
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withValues(alpha: 0.9), // Brand color background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/images/logo.png",
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // Tagline
              const Text(
                "Enabling Minds, Passionately",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // Loader
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}