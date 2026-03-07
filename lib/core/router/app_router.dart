import 'package:buddymentor/features/auth/screens/onboarding/roleSelectionScreen.dart';
import 'package:buddymentor/features/auth/screens/splash_screen.dart';
import 'package:buddymentor/features/auth/screens/reset_password/reset_otp_screen.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_dashboard_shell.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_home_page/screens/mentee_home_screen.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/mentee_map_screen.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_profile/screens/mentee_profile_edit.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_profile/screens/mentee_profile_screen.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_program_timeline/screens/mentee_timeline_screen.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_wisdomtree/mentee_tree_screen.dart';
import 'package:buddymentor/features/mentor/dashboard/views/mentor_dashboard_screen.dart';
import 'package:buddymentor/features/industry/dashboard/views/industry_dashboard_screen.dart';
import 'package:buddymentor/features/institution/dashboard/views/institution_dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/role', builder: (_, __) => const RoleSelectionScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

    //  Registration
    GoRoute(
      path: '/register/mentee',
      builder: (_, __) => const MenteeRegisterScreen(),
    ),
    GoRoute(
      path: '/register/mentor',
      builder: (_, __) => const MentorRegisterScreen(),
    ),
    GoRoute(
      path: '/register/industry',
      builder: (_, __) => const IndustryRegisterScreen(),
    ),
    GoRoute(
      path: '/register/institution',
      builder: (_, __) => const InstitutionRegisterScreen(),
    ),

    // Reset Password
    GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(
      path: '/resetotp/:email',
      builder: (_, state) => ResetOtpScreen(email: state.pathParameters['email']!),
    ),
    GoRoute(
      path: '/reset/:email',
      builder: (_, state) => ResetPasswordScreen(email: state.pathParameters['email']),
    ),
    GoRoute(
      path: '/reset/success',
      builder: (_, __) => const PasswordResetedScreen(),
    ),

    //registration OTP
    GoRoute(
      path: '/otp/:email',
      builder: (_, state) => OtpScreen(
        email: state.pathParameters['email'],
      ),
    ),
    GoRoute(path: '/verified', builder: (_, __) => const VerifiedScreen()),

    /// DASHBOARD SHELL (Persistent Bottom Bar)
    ShellRoute(
      builder: (context, state, child) {
        return MenteeDashboardShell(child: child);
      },
      // Nested routes for mentee dashboard
      routes: [

        // Home
        GoRoute(
          path: '/menteedashboard',
          builder: (_, __) => const MenteeHomeScreen(),
        ),

        // Program Timeline
        GoRoute(
          path: '/menteetimeline',
          builder: (_, __) => const MenteeTimelineScreen(),
        ),

        //  Circular Map
        GoRoute(
          path: '/menteemap',
          builder: (_, __) => const MenteeMapScreen(),
        ),

        // Wisdom Tree
        GoRoute(
          path: '/menteetree',
          builder: (_, __) => const MenteeTreeScreen(),
        ),

        // Profile
        GoRoute(
          path: '/menteeprofile',
          builder: (_, __) => const MenteeProfileScreen(),
        ),
        GoRoute(
          path: '/menteeprofile/edit',
          builder: (_, __) => const MenteeProfileEditScreen(),
        ),
      ],
    ),

    // Other Dashboard Routes
    GoRoute(
      path: '/mentordashboard',
      builder: (_, __) => const MentorDashboardScreen(),
    ),
    GoRoute(
      path: '/industrydashboard',
      builder: (_, __) => const IndustryDashboardScreen(),
    ),
    GoRoute(
      path: '/institutiondashboard',
      builder: (_, __) => const InstitutionDashboardScreen(),
    ),
  ],
);
