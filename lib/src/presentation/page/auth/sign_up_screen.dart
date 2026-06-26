import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/constant.dart';
import 'package:bloc_clean_architecture/src/comman/toast.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_elevated_button.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (_password != _confirmPassword) {
        showToast(
          msg: "Passwords do not match",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      // Simulate a network delay for registration uplink
      Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        showToast(
          msg: "Account uplink established! Please sign in.",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Retrieve SplashTheme parameters for consistent CyberTalent styling
    final splashTheme = SplashTheme.of(context);
    final backgroundColor = splashTheme.backgroundColor;
    final gridColor = splashTheme.gridColor;
    final centerGlowColor = splashTheme.centerGlowColor;
    final bottomGlowColor = splashTheme.bottomGlowColor;

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

          // Radial atmospheric glows
          Positioned(
            top: -150,
            left: -150,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    centerGlowColor.withOpacity(isDark ? 0.08 : 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            width: 450,
            height: 450,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    bottomGlowColor.withOpacity(isDark ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _buildLogoHeader(context, splashTheme),
                        const SizedBox(height: 28),
                        
                        // Name input field
                        CustomTextFormField(
                          hintText: 'Full Name',
                          textFieldType: TextFieldType.alphabet,
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: theme.hintColor.withOpacity(0.7),
                          ),
                          onChanged: (v) => _name = v,
                        ),
                        const SizedBox(height: 12),
                        
                        // Email input field
                        CustomTextFormField(
                          hintText: 'Email',
                          textFieldType: TextFieldType.email,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: theme.hintColor.withOpacity(0.7),
                          ),
                          onChanged: (v) => _email = v,
                        ),
                        const SizedBox(height: 12),
                        
                        // Password input field
                        CustomTextFormField(
                          obscureText: _obscurePassword,
                          hintText: 'Password',
                          textFieldType: TextFieldType.password,
                          prefixIcon: Icon(
                            Icons.lock_open_rounded,
                            color: theme.hintColor.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: FaIcon(
                              _obscurePassword
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 18,
                              color: theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                          onChanged: (v) => _password = v,
                        ),
                        const SizedBox(height: 12),

                        // Confirm Password input field
                        CustomTextFormField(
                          obscureText: _obscureConfirmPassword,
                          hintText: 'Confirm Password',
                          textFieldType: TextFieldType.password,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: theme.hintColor.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                            icon: FaIcon(
                              _obscureConfirmPassword
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 18,
                              color: theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                          onChanged: (v) => _confirmPassword = v,
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        CustomElevatedButton(
                          onTap: _handleRegister,
                          isLoading: _isLoading,
                          labelLoading: 'CREATING UPLINK...',
                          label: 'Register',
                        ),
                        const SizedBox(height: 24),
                        _buildDivider(context, theme),
                        const SizedBox(height: 20),
                        _buildOtherSignOption(context, theme, splashTheme),
                        const SizedBox(height: 28),
                        _buildLoginButton(context, splashTheme),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader(BuildContext context, SplashTheme splashTheme) {
    return Column(
      children: [
        // Glassmorphic mini briefcase icon card
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: splashTheme.logoCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: splashTheme.logoCardBorderColor),
            boxShadow: [
              BoxShadow(
                color: splashTheme.logoCardShadowColor,
                blurRadius: 15,
                spreadRadius: 1,
              )
            ],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: splashTheme.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(
              Icons.work_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),

        // Brand Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NEON ',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: splashTheme.neonTitleColor,
                letterSpacing: -0.5,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: splashTheme.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'JOB LINK',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Title and Subtitle
        Text(
          'Create Account',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: splashTheme.neonTitleColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Join the neural network and apply today',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: splashTheme.taglineColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context, ThemeData theme) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 0.5,
            color: theme.dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR SIGN UP WITH',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.hintColor.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: theme.dividerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSignOption(
      BuildContext context, ThemeData theme, SplashTheme splashTheme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Connection Button
        GestureDetector(
          onTap: () {
            // Future google sign up
          },
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: splashTheme.logoCardBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: splashTheme.logoCardBorderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FaIcon(
              FontAwesomeIcons.google,
              size: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 20),
        
        // Apple Connection Button
        GestureDetector(
          onTap: () {
            // Future apple sign up
          },
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: splashTheme.logoCardBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: splashTheme.logoCardBorderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FaIcon(
              FontAwesomeIcons.apple,
              size: 22,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, SplashTheme splashTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Already have an account?',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: splashTheme.taglineColor,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
          },
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: splashTheme.gradientColors.first,
            ),
          ),
        )
      ],
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