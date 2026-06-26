import 'dart:ui';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Opportunities',
      'description':
          'Browse job openings from top companies in one place. Your next career leap into the future starts with a single tap.',
      'icon': 'work_outline',
      'chip': '500+ New Jobs',
    },
    {
      'title': 'Track Applications',
      'description':
          'Monitor your progress with real-time updates. Stay ahead of the competition with our smart tracking system.',
      'icon': 'track_changes',
      'chip': 'Real-time Sync',
    },
    {
      'title': 'Get Hired Fast',
      'description':
          'Connect directly with recruiters and land your dream job quicker. Your digital portfolio speaks for itself.',
      'icon': 'rocket_launch',
      'chip': 'Direct Access',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
    }
  }

  void _onSkip() {
    context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work_outline':
        return Icons.work_outline;
      case 'track_changes':
        return Icons.track_changes;
      case 'rocket_launch':
        return Icons.rocket_launch;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final splashTheme = SplashTheme.of(context);

    final primaryColor = splashTheme.gradientColors.first;
    final secondaryColor = splashTheme.gradientColors.last;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final hintColor = theme.hintColor;
    final dividerColor = theme.dividerColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Mesh & Glows
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: const SizedBox(),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 140, sigmaY: 140),
                child: const SizedBox(),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NEON HIRING',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: _onSkip,
                        child: Text(
                          'SKIP',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: hintColor,
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
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hero Illustration Area
                            SizedBox(
                              width: double.infinity,
                              height: 320,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Decorative Pulsing Glow
                                  Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor.withOpacity(0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 100,
                                          spreadRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Central Glass Card (Simulating the 3D Image)
                                  Container(
                                    width: 280,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      color: cardColor.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.2),
                                          blurRadius: 15,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                        child: Center(
                                          child: Icon(
                                            _getIconData(data['icon']!),
                                            size: 100,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Accessory Floating Chip
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cardColor.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: secondaryColor,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: secondaryColor.withOpacity(0.3),
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        data['chip']!,
                                        style: GoogleFonts.inter(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Text Content
                            Text(
                              data['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data['description']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                height: 1.5,
                                color: hintColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Progress Indicators
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32 : 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? primaryColor
                              : dividerColor,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.4),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Actions Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.5),
                    border: Border(
                      top: BorderSide(
                        color: dividerColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ).copyWith(
                              shadowColor: WidgetStateProperty.all(
                                primaryColor.withOpacity(0.4),
                              ),
                              elevation: WidgetStateProperty.resolveWith((states) {
                                return 10.0;
                              }),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _onboardingData.length - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_currentPage < _onboardingData.length - 1) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 20),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _onSkip,
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.inter(
                                  color: hintColor,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: GoogleFonts.inter(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
