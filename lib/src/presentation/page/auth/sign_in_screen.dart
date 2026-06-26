import 'package:bloc_clean_architecture/src/comman/constant.dart';
import 'package:bloc_clean_architecture/src/comman/enum.dart';
import 'package:bloc_clean_architecture/src/comman/toast.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_elevated_button.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

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

    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        if (state.state == RequestState.loaded) {
          context.read<AuthenticatorWatcherBloc>().add(
                const AuthenticatorWatcherEvent.authCheckRequest(),
              );
          context.goNamed(AppRoutes.DASHBOARD_ROUTE_NAME);
        }
        if (state.state == RequestState.error) {
          showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
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
                            const SizedBox(height: 32),
                            
                            // Email input field
                            CustomTextFormField(
                              hintText: 'Email',
                              textFieldType: TextFieldType.email,
                              prefixIcon: Icon(
                                Icons.mail_outline_rounded,
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                              onChanged: (v) {
                                context
                                    .read<SignInFormBloc>()
                                    .add(SignInFormEvent.emailOnChanged(v));
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Password input field
                            CustomTextFormField(
                              obscureText: _obscureText,
                              hintText: 'Password',
                              textFieldType: TextFieldType.password,
                              prefixIcon: Icon(
                                Icons.lock_open_rounded,
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: FaIcon(
                                  _obscureText
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 18,
                                  color: theme.hintColor.withOpacity(0.7),
                                ),
                              ),
                              onChanged: (v) {
                                context
                                    .read<SignInFormBloc>()
                                    .add(SignInFormEvent.passwordOnChanged(v));
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildForgotPassword(context, splashTheme),
                            const SizedBox(height: 24),

                            // Submit Button
                            CustomElevatedButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<SignInFormBloc>()
                                      .add(const SignInFormEvent.signInWithEmail());
                                }
                              },
                              isLoading: state.state == RequestState.loading,
                              labelLoading: 'AUTHENTICATING...',
                              label: 'Sign In',
                            ),
                            const SizedBox(height: 24),
                            _buildDivider(context, theme),
                            const SizedBox(height: 20),
                            _buildOtherSignOption(context, theme, splashTheme),
                            const SizedBox(height: 28),
                            _buildRegisterButton(context, splashTheme),
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
      },
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
          'Welcome Back',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: splashTheme.neonTitleColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in to continue your career uplink',
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

  Widget _buildForgotPassword(BuildContext context, SplashTheme splashTheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // Future expansion
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: splashTheme.gradientColors.first,
          ),
        ),
      ),
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
            'OR CONNECT WITH',
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
            context
                .read<SignInFormBloc>()
                .add(const SignInFormEvent.signInWithGoogle());
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
            // Future Apple login integration
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

  Widget _buildRegisterButton(BuildContext context, SplashTheme splashTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Don\'t have an account?',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: splashTheme.taglineColor,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            context.pushNamed(AppRoutes.SIGNUP_ROUTE_NAME);
          },
          child: Text(
            'Register',
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
