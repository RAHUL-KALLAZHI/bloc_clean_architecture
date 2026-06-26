import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _progress = 0.0;
  String _statusText = "Initializing Neural Link...";
  bool _authChecked = false;
  AuthenticatorWatcherState? _targetAuthState;
  Timer? _progressTimer;

  late AnimationController _scanlineController;
  late AnimationController _fadeController;

  final List<String> _statusMessages = [
    "Initializing Neural Link...",
    "Syncing Market Data...",
    "Encrypting Credentials...",
    "Optimizing Talent Grid...",
    "Ready for Uplink"
  ];

  @override
  void initState() {
    super.initState();

    // Trigger auth check request
    Future.microtask(
      () => context.read<AuthenticatorWatcherBloc>().add(
            const AuthenticatorWatcherEvent.authCheckRequest(),
          ),
    );

    // Initialize animation controllers
    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Trigger tagline fade-in
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fadeController.forward();
      }
    });

    // Simulate loading progress bar
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) return;
      setState(() {
        // Increment progress non-linearly
        _progress += 2.0;
        if (_progress >= 100.0) {
          _progress = 100.0;
          _progressTimer?.cancel();
          _statusText = _statusMessages[4];
          _checkNavigation();
        } else {
          final msgIndex = ((_progress / 100.0) * 4).floor();
          _statusText = _statusMessages[msgIndex];
        }
      });
    });
  }

  void _checkNavigation() {
    if (_progress >= 100.0 && _authChecked && _targetAuthState != null) {
      // Small delay for fluid UI transition
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _targetAuthState!.maybeMap(
          orElse: () {},
          authenticated: (_) {
            context.replaceNamed(AppRoutes.DASHBOARD_ROUTE_NAME);
          },
          isFirstTime: (_) {
            context.replaceNamed(AppRoutes.ONBOARDING_ROUTE_NAME);
          },
          unauthenticated: (_) {
            context.replaceNamed(AppRoutes.LOGIN_ROUTE_NAME);
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _scanlineController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Retrieve SplashTheme from active ThemeData
    final splashTheme = theme.extension<SplashTheme>()!;

    final backgroundColor = splashTheme.backgroundColor;
    final gridColor = splashTheme.gridColor;
    final scanlineGradientColor = splashTheme.scanlineColor;
    final centerGlowColor = splashTheme.centerGlowColor;
    final bottomGlowColor = splashTheme.bottomGlowColor;

    final logoCardBg = splashTheme.logoCardBg;
    final logoCardBorder = Border.all(
      color: splashTheme.logoCardBorderColor,
    );
    final logoCardShadow = BoxShadow(
      color: splashTheme.logoCardShadowColor,
      blurRadius: 20,
      spreadRadius: 2,
    );

    final gradientColors = splashTheme.gradientColors;

    final neonTitleColor = splashTheme.neonTitleColor;
    final taglineColor = splashTheme.taglineColor;

    final statusColor = splashTheme.statusColor;
    final percentageColor = splashTheme.percentageColor;

    final progressBarTrackBg = splashTheme.progressBarTrackBg;
    final progressBarTrackBorderColor = splashTheme.progressBarTrackBorderColor;
    final progressBarGlowColor = splashTheme.progressBarGlowColor;

    final versionDividerColor = splashTheme.versionDividerColor;
    final versionTextColor = splashTheme.versionTextColor;

    return BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
      listener: (context, state) {
        setState(() {
          _authChecked = true;
          _targetAuthState = state;
        });
        _checkNavigation();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // Ambient digital grid overlay
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(color: gridColor),
              ),
            ),

            // Scanline animation
            AnimatedBuilder(
              animation: _scanlineController,
              builder: (context, child) {
                final topPos = _scanlineController.value * size.height - 100;
                return Positioned(
                  top: topPos,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          scanlineGradientColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Radial atmospheric glows
            Positioned(
              top: size.height * 0.5 - 300,
              left: size.width * 0.5 - 300,
              width: 600,
              height: 600,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      centerGlowColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              width: 400,
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      bottomGlowColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Central Main Content
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glassmorphic central briefcase logo card
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: logoCardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: logoCardBorder,
                        boxShadow: [logoCardShadow],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.work_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Title NEON JOB LINK
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'NEON ',
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: neonTitleColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'JOB LINK',
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tagline Slide & Fade
                    AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeController.value,
                          child: Transform.translate(
                            offset:
                                Offset(0, 16 * (1.0 - _fadeController.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'FUTURE-PROOF YOUR CAREER',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: taglineColor,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom loading status and progress
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status and percentage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _statusText.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${_progress.toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: percentageColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Progress Bar Track
                      Container(
                        height: 3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: progressBarTrackBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: progressBarTrackBorderColor,
                            width: 0.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Progress gradient fill
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: constraints.maxWidth *
                                      (_progress / 100.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: progressBarGlowColor
                                            .withOpacity(0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Version string footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 0.5,
                            width: 24,
                            color: versionDividerColor,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'PROTOCOL V2.04.88',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: versionTextColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            height: 0.5,
                            width: 24,
                            color: versionDividerColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
