import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The brand guideline, as code.
///
/// Every colour, radius, spacing step, shadow and type style in the app comes
/// from here, so the whole look can be re-skinned from this one file.
abstract final class Brand {
  // ── Palette ────────────────────────────────────────────────────────────
  static const water = Color(0xFF2F8CFF);
  static const waterDeep = Color(0xFF1C64D8);
  static const waterLight = Color(0xFF9AD4FF);
  static const foam = Color(0xFFE3F2FF);
  static const sky = Color(0xFFF4F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF13283F);
  static const inkSoft = Color(0xFF61758B);
  static const line = Color(0xFFE1ECF7);
  static const coral = Color(0xFFFF6F61);
  static const coralDeep = Color(0xFFE0483A);
  static const sun = Color(0xFFFFC23D);
  static const sunDeep = Color(0xFFE59E0B);
  static const flame = Color(0xFFFF8A3D);
  static const leaf = Color(0xFF2EC27E);
  static const leafDeep = Color(0xFF1E9E63);
  static const disabled = Color(0xFFD5DEE8);
  static const disabledDeep = Color(0xFFB9C6D3);

  // ── Shape ──────────────────────────────────────────────────────────────
  static const radiusS = 12.0;
  static const radiusM = 20.0;
  static const radiusL = 28.0;

  // ── Spacing (4-pt grid) ────────────────────────────────────────────────
  static const gap1 = 4.0;
  static const gap2 = 8.0;
  static const gap3 = 12.0;
  static const gap4 = 16.0;
  static const gap5 = 20.0;
  static const gap6 = 24.0;
  static const gap8 = 32.0;

  // ── Elevation ──────────────────────────────────────────────────────────
  static const shadowCard = [
    BoxShadow(color: Color(0x141C64D8), blurRadius: 18, offset: Offset(0, 6)),
  ];
  static const shadowFloat = [
    BoxShadow(color: Color(0x261C64D8), blurRadius: 30, offset: Offset(0, 12)),
  ];

  // ── Motion ─────────────────────────────────────────────────────────────
  static const fast = Duration(milliseconds: 160);
  static const medium = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 600);

  // ── Type ───────────────────────────────────────────────────────────────
  /// Rounded, playful headline face.
  static TextStyle display(
    double size, {
    Color color = ink,
    FontWeight weight = FontWeight.w600,
  }) => GoogleFonts.fredoka(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.1,
  );

  /// Friendly, readable body face.
  static TextStyle body(
    double size, {
    Color color = ink,
    FontWeight weight = FontWeight.w600,
  }) => GoogleFonts.nunito(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.35,
  );

  static BoxDecoration card({Color color = surface}) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radiusL),
    boxShadow: shadowCard,
  );

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: water,
        primary: water,
        surface: sky,
      ),
      scaffoldBackgroundColor: sky,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: GoogleFonts.nunito().fontFamily,
        bodyColor: ink,
        displayColor: ink,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: water,
        inactiveTrackColor: foam,
        thumbColor: water,
        overlayColor: water.withValues(alpha: 0.12),
        trackHeight: 10,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 14,
          elevation: 2,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: body(14, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}