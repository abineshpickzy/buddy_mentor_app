import 'package:buddymentor/features/auth/screens/roleSelectionScreen.dart';
import 'package:buddymentor/features/auth/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(
      path: '/reset',
      builder: (_, state) => ResetPasswordScreen(
        email: (state.extra as Map<String, dynamic>?)?['email'],
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (_, state) => OtpScreen(email: state.extra as String?),
    ),
    GoRoute(path: '/verified', builder: (_, __) => const VerifiedScreen()),
    GoRoute(path: '/role', builder: (_, __) => const RoleSelectionScreen()),
  ],
);
