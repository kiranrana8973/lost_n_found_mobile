import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_item.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../auth/presentation/pages/login_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      title: 'Report Lost Items',
      description:
          'Quickly report lost items with photos and detailed descriptions. Our smart matching helps reunite you with your belongings.',
      icon: Icons.travel_explore_rounded,
      color: AppColors.onboarding1Primary,
      gradientColors: [AppColors.onboarding1Primary, AppColors.onboarding1Secondary],
    ),
    OnboardingItem(
      title: 'Find & Discover',
      description:
          'Browse through found items in real-time. Advanced filters help you find exactly what you\'re looking for.',
      icon: Icons.location_searching_rounded,
      color: AppColors.onboarding2Primary,
      gradientColors: [AppColors.onboarding2Primary, AppColors.onboarding2Secondary],
    ),
    OnboardingItem(
      title: 'Connect Instantly',
      description:
          'Chat directly with finders or owners. Get instant notifications and recover your items quickly and securely.',
      icon: Icons.forum_rounded,
      color: AppColors.onboarding3Primary,
      gradientColors: [AppColors.onboarding3Primary, AppColors.onboarding3Secondary],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skipOnboarding() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    AppRoutes.pushReplacement(context, const LoginPage());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Skip Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: AppColors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingItems.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _animationController,
                      child: OnboardingContent(
                        item: _onboardingItems[index],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Page Indicator
                    PageIndicator(
                      itemCount: _onboardingItems.length,
                      currentPage: _currentPage,
                      activeColor: _onboardingItems[_currentPage].color,
                    ),
                    const SizedBox(height: 32),

                    // Next/Get Started Button
                    GradientButton(
                      text: _currentPage == _onboardingItems.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                      gradient: LinearGradient(
                        colors: _onboardingItems[_currentPage].gradientColors,
                      ),
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
