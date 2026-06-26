import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Retrieve SplashTheme parameters for consistent styling
    final splashTheme = SplashTheme.of(context);
    final backgroundColor = splashTheme.backgroundColor;
    final gridColor = splashTheme.gridColor;

    // Dynamic error specific accent colors
    final errorColor = theme.colorScheme.error;
    final warningGlowColor = errorColor.withOpacity(isDark ? 0.15 : 0.08);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Ambient digital grid overlay
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(color: gridColor),
            ),
          ),

          // Central warning radial glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 200,
            left: MediaQuery.of(context).size.width * 0.5 - 200,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    warningGlowColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Error page main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Glassmorphic warning icon card
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: splashTheme.logoCardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: errorColor.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: errorColor.withOpacity(isDark ? 0.2 : 0.1),
                                blurRadius: 20,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: errorColor,
                          ),
                        ),
                      ),

                      // Brand or Error code text
                      Text(
                        '404 / SYSTEM OFFLINE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: errorColor,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        'Uplink Disconnected',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: splashTheme.neonTitleColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'The grid pathway you are attempting to access does not exist or has been decommissioned from the matrix.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: splashTheme.taglineColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Action Button
                      CustomElevatedButton(
                        onTap: () {
                          context.goNamed(AppRoutes.DASHBOARD_ROUTE_NAME);
                        },
                        label: 'RETURN TO HOME BASE',
                        color: isDark ? const Color(0xFF161616) : Colors.white,
                        labelColor: splashTheme.neonTitleColor,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
