import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/utils/app_preferences.dart';
import '../../../../core/constants/app_sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Structured Mentoring for Engineering Excellence",
      "subtitle":
          "Follow weekly roadmaps, track your progress, and earn certification through disciplined mentoring.",
    },
    {
      "image": "assets/images/onboarding1.png",
      "title": "Learn from Industry Experts",
      "subtitle":
          "Connect with mentors, build real-world skills, and accelerate your career growth.",
    },
  ];

  void _nextPage() async {
    if (_currentIndex == 1) {
      await AppPreferences.setOnboardingCompleted(true);
      if (mounted) context.go('/role');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    /// FIRST SLIDE (same as before)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(_pages[index]["image"]!, height: 250),
                        const SizedBox(height: 40),
                        Text(
                          _pages[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  } else {
                    /// SECOND SLIDE (BDM Master layout)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        Text(
                          "BDM Master",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),

                        const SizedBox(height: 30),

                        _featureCard(
                          icon: Icons.menu_book_outlined,
                          title: "Weekly Mentoring",
                          subtitle:
                              "Structured weekly sessions with domain experts and industry mentors",
                        ),

                        const SizedBox(height: 16),

                        _featureCard(
                          icon: Icons.show_chart_outlined,
                          title: "Progress Tracking",
                          subtitle:
                              "Visual dashboards to monitor your learning journey week by week",
                        ),

                        const SizedBox(height: 16),

                        _featureCard(
                          icon: Icons.workspace_premium_outlined,
                          title: "Certification",
                          subtitle:
                              "Earn recognized credentials upon completing your mentoring program",
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            /// Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentIndex == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? const Color(0xFF2F4B9A)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            AppButton(
              text: _currentIndex == 1 ? "Get Started" : "Next",
              onPressed: _nextPage,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
Widget _featureCard({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2F4B9A)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
