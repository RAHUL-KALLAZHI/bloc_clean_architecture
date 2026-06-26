import 'package:bloc_clean_architecture/src/comman/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    cardColor: ColorLight.card,
    disabledColor: ColorLight.disabledButton,
    // highlightColor: ColorLight.fontTitle,
    hintColor: ColorLight.fontSubtitle,
    indicatorColor: ColorLight.primary,
    iconTheme: const IconThemeData(
      color: ColorLight.fontTitle,
    ),
    primaryColor: ColorLight.primary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorLight.primary,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
        color: ColorLight.disabledButton,
      ),
    ),
    scaffoldBackgroundColor: ColorLight.background,
    dividerColor: ColorLight.divider,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    extensions: [
      const SplashTheme(
        backgroundColor: ColorLight.splashBg,
        gridColor: ColorLight.splashGrid,
        scanlineColor: ColorLight.splashScanline,
        centerGlowColor: ColorLight.splashCenterGlow,
        bottomGlowColor: ColorLight.splashBottomGlow,
        logoCardBg: ColorLight.splashLogoCardBg,
        logoCardBorderColor: ColorLight.splashLogoCardBorder,
        logoCardShadowColor: ColorLight.splashLogoCardShadow,
        gradientColors: ColorLight.splashGradient,
        neonTitleColor: ColorLight.splashNeonTitle,
        taglineColor: ColorLight.splashTagline,
        statusColor: ColorLight.splashStatusColor,
        percentageColor: ColorLight.splashPercentageColor,
        progressBarTrackBg: ColorLight.splashProgressBarTrackBg,
        progressBarTrackBorderColor: ColorLight.splashProgressBarTrackBorder,
        progressBarGlowColor: ColorLight.splashProgressBarGlow,
        versionDividerColor: ColorLight.splashVersionDivider,
        versionTextColor: ColorLight.splashVersionText,
      ),
    ],
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      displayMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.poppins(
        color: ColorLight.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: GoogleFonts.poppins(
        color: ColorLight.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    cardColor: ColorDark.card,
    disabledColor: ColorDark.disabledButton,
    hintColor: ColorDark.fontSubtitle,
    indicatorColor: ColorDark.primary,
    iconTheme: const IconThemeData(
      color: ColorDark.fontTitle,
    ),
    primaryColor: ColorDark.primary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorDark.primary,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
        color: ColorDark.disabledButton,
      ),
    ),
    scaffoldBackgroundColor: ColorDark.background,
    dividerColor: ColorDark.divider,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    extensions: [
      const SplashTheme(
        backgroundColor: ColorDark.splashBg,
        gridColor: ColorDark.splashGrid,
        scanlineColor: ColorDark.splashScanline,
        centerGlowColor: ColorDark.splashCenterGlow,
        bottomGlowColor: ColorDark.splashBottomGlow,
        logoCardBg: ColorDark.splashLogoCardBg,
        logoCardBorderColor: ColorDark.splashLogoCardBorder,
        logoCardShadowColor: ColorDark.splashLogoCardShadow,
        gradientColors: ColorDark.splashGradient,
        neonTitleColor: ColorDark.splashNeonTitle,
        taglineColor: ColorDark.splashTagline,
        statusColor: ColorDark.splashStatusColor,
        percentageColor: ColorDark.splashPercentageColor,
        progressBarTrackBg: ColorDark.splashProgressBarTrackBg,
        progressBarTrackBorderColor: ColorDark.splashProgressBarTrackBorder,
        progressBarGlowColor: ColorDark.splashProgressBarGlow,
        versionDividerColor: ColorDark.splashVersionDivider,
        versionTextColor: ColorDark.splashVersionText,
      ),
    ],
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      displayMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

class SplashTheme extends ThemeExtension<SplashTheme> {
  final Color backgroundColor;
  final Color gridColor;
  final Color scanlineColor;
  final Color centerGlowColor;
  final Color bottomGlowColor;
  final Color logoCardBg;
  final Color logoCardBorderColor;
  final Color logoCardShadowColor;
  final List<Color> gradientColors;
  final Color neonTitleColor;
  final Color taglineColor;
  final Color statusColor;
  final Color percentageColor;
  final Color progressBarTrackBg;
  final Color progressBarTrackBorderColor;
  final Color progressBarGlowColor;
  final Color versionDividerColor;
  final Color versionTextColor;

  const SplashTheme({
    required this.backgroundColor,
    required this.gridColor,
    required this.scanlineColor,
    required this.centerGlowColor,
    required this.bottomGlowColor,
    required this.logoCardBg,
    required this.logoCardBorderColor,
    required this.logoCardShadowColor,
    required this.gradientColors,
    required this.neonTitleColor,
    required this.taglineColor,
    required this.statusColor,
    required this.percentageColor,
    required this.progressBarTrackBg,
    required this.progressBarTrackBorderColor,
    required this.progressBarGlowColor,
    required this.versionDividerColor,
    required this.versionTextColor,
  });

  @override
  SplashTheme copyWith({
    Color? backgroundColor,
    Color? gridColor,
    Color? scanlineColor,
    Color? centerGlowColor,
    Color? bottomGlowColor,
    Color? logoCardBg,
    Color? logoCardBorderColor,
    Color? logoCardShadowColor,
    List<Color>? gradientColors,
    Color? neonTitleColor,
    Color? taglineColor,
    Color? statusColor,
    Color? percentageColor,
    Color? progressBarTrackBg,
    Color? progressBarTrackBorderColor,
    Color? progressBarGlowColor,
    Color? versionDividerColor,
    Color? versionTextColor,
  }) {
    return SplashTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gridColor: gridColor ?? this.gridColor,
      scanlineColor: scanlineColor ?? this.scanlineColor,
      centerGlowColor: centerGlowColor ?? this.centerGlowColor,
      bottomGlowColor: bottomGlowColor ?? this.bottomGlowColor,
      logoCardBg: logoCardBg ?? this.logoCardBg,
      logoCardBorderColor: logoCardBorderColor ?? this.logoCardBorderColor,
      logoCardShadowColor: logoCardShadowColor ?? this.logoCardShadowColor,
      gradientColors: gradientColors ?? this.gradientColors,
      neonTitleColor: neonTitleColor ?? this.neonTitleColor,
      taglineColor: taglineColor ?? this.taglineColor,
      statusColor: statusColor ?? this.statusColor,
      percentageColor: percentageColor ?? this.percentageColor,
      progressBarTrackBg: progressBarTrackBg ?? this.progressBarTrackBg,
      progressBarTrackBorderColor: progressBarTrackBorderColor ?? this.progressBarTrackBorderColor,
      progressBarGlowColor: progressBarGlowColor ?? this.progressBarGlowColor,
      versionDividerColor: versionDividerColor ?? this.versionDividerColor,
      versionTextColor: versionTextColor ?? this.versionTextColor,
    );
  }

  @override
  SplashTheme lerp(ThemeExtension<SplashTheme>? other, double t) {
    if (other is! SplashTheme) {
      return this;
    }
    return SplashTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      gridColor: Color.lerp(gridColor, other.gridColor, t)!,
      scanlineColor: Color.lerp(scanlineColor, other.scanlineColor, t)!,
      centerGlowColor: Color.lerp(centerGlowColor, other.centerGlowColor, t)!,
      bottomGlowColor: Color.lerp(bottomGlowColor, other.bottomGlowColor, t)!,
      logoCardBg: Color.lerp(logoCardBg, other.logoCardBg, t)!,
      logoCardBorderColor: Color.lerp(logoCardBorderColor, other.logoCardBorderColor, t)!,
      logoCardShadowColor: Color.lerp(logoCardShadowColor, other.logoCardShadowColor, t)!,
      gradientColors: gradientColors,
      neonTitleColor: Color.lerp(neonTitleColor, other.neonTitleColor, t)!,
      taglineColor: Color.lerp(taglineColor, other.taglineColor, t)!,
      statusColor: Color.lerp(statusColor, other.statusColor, t)!,
      percentageColor: Color.lerp(percentageColor, other.percentageColor, t)!,
      progressBarTrackBg: Color.lerp(progressBarTrackBg, other.progressBarTrackBg, t)!,
      progressBarTrackBorderColor: Color.lerp(progressBarTrackBorderColor, other.progressBarTrackBorderColor, t)!,
      progressBarGlowColor: Color.lerp(progressBarGlowColor, other.progressBarGlowColor, t)!,
      versionDividerColor: Color.lerp(versionDividerColor, other.versionDividerColor, t)!,
      versionTextColor: Color.lerp(versionTextColor, other.versionTextColor, t)!,
    );
  }
}
