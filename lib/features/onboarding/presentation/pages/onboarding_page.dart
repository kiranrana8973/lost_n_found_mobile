import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_item.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_provider.dart';
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

  List<OnboardingItem> _getOnboardingItems(AppLocalizations? l10n) {
    return [
      OnboardingItem(
        title: l10n?.reportLostItemsTitle ?? 'Report Lost Items',
        description: l10n?.reportLostItemsDesc ??
            'Quickly report lost items with photos and detailed descriptions. Our smart matching helps reunite you with your belongings.',
        icon: Icons.travel_explore_rounded,
        color: AppColors.onboarding1Primary,
        gradientColors: [AppColors.onboarding1Primary, AppColors.onboarding1Secondary],
      ),
      OnboardingItem(
        title: l10n?.findDiscoverTitle ?? 'Find & Discover',
        description: l10n?.findDiscoverDesc ??
            'Browse through found items in real-time. Advanced filters help you find exactly what you\'re looking for.',
        icon: Icons.location_searching_rounded,
        color: AppColors.onboarding2Primary,
        gradientColors: [AppColors.onboarding2Primary, AppColors.onboarding2Secondary],
      ),
      OnboardingItem(
        title: l10n?.connectInstantlyTitle ?? 'Connect Instantly',
        description: l10n?.connectInstantlyDesc ??
            'Chat directly with finders or owners. Get instant notifications and recover your items quickly and securely.',
        icon: Icons.forum_rounded,
        color: AppColors.onboarding3Primary,
        gradientColors: [AppColors.onboarding3Primary, AppColors.onboarding3Secondary],
      ),
    ];
  }

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
    if (_currentPage < 2) {
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

  Widget _buildLanguageSwitch(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.watch(localeProvider.notifier);
    final isEnglish = ref.watch(localeProvider).languageCode == 'en';

    return GestureDetector(
      onTap: () => localeNotifier.toggleLanguage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? Colors.white.withAlpha(20)
              : AppColors.white30,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withAlpha(77),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEnglish ? 'EN' : 'NE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.language_rounded,
              size: 20,
              color: context.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingItems = _getOnboardingItems(l10n);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: context.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Language Switch and Skip Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLanguageSwitch(context, ref),
                    TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: context.isDarkMode
                            ? Colors.white.withAlpha(20)
                            : AppColors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        l10n?.skip ?? 'Skip',
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
                  itemCount: onboardingItems.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _animationController,
                      child: OnboardingContent(
                        item: onboardingItems[index],
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
                      itemCount: onboardingItems.length,
                      currentPage: _currentPage,
                      activeColor: onboardingItems[_currentPage].color,
                    ),
                    const SizedBox(height: 32),

                    // Next/Get Started Button
                    GradientButton(
                      text: _currentPage == onboardingItems.length - 1
                          ? (l10n?.getStarted ?? 'Get Started')
                          : (l10n?.next ?? 'Next'),
                      onPressed: _nextPage,
                      gradient: LinearGradient(
                        colors: onboardingItems[_currentPage].gradientColors,
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
