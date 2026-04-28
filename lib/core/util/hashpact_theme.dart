/*
* Created by Connel Asikong on 28/04/2026
*
*/

import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Backgrounds (darkest to lightest) ──────────────────────
  static const background = Color(0xFF060B14); // page bg — near black
  static const surface = Color(0xFF0E1624); // cards, sheets
  static const surfaceHigh = Color(0xFF162032); // elevated surfaces
  static const border = Color(0xFF1E2D42); // dividers, outlines

  // ── Brand ────────────────────────────────────────────────
  static const primary = Color(0xFF4DA2FF); // SUI electric blue
  static const primaryDim = Color(
    0xFF1A3A5C,
  ); // blue at low opacity — for bg fills
  static const accent = Color(0xFF00D4FF); // cyan highlight

  // ── Text ────────────────────────────────────────────────
  static const textPrimary = Color(
    0xFFE6EDF3,
  ); // main text — not pure white (easier on eyes)
  static const textSecondary = Color(0xFF8B949E); // labels, hints
  static const textMuted = Color(0xFF484F58); // placeholder, disabled

  // ── Semantic ─────────────────────────────────────────────
  static const success = Color(0xFF3FB950); // completed swap, confirmed tx
  static const warning = Color(0xFFD29922); // expiring soon, pending
  static const danger = Color(0xFFF85149); // failed, declined, error

  // ── Token colours (used in token cards + swap bubbles) ───
  static const suiBlue = Color(0xFF4DA2FF);
  static const btcOrange = Color(0xFFF7931A);
  static const usdcBlue = Color(0xFF2775CA);
  static const usdtGreen = Color(0xFF26A17B);
}

abstract class AppTextStyles {
  // ── Headings ─────────────────────────────────────────────
  static const heading1 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const heading2 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const heading3 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ─────────────────────────────────────────────────
  static const body = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Labels ───────────────────────────────────────────────
  static const label = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.6,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Monospace — addresses, hashes, amounts ────────────────
  // Use this any time you display: 0x123..., npub1..., tx hashes,
  // or token amounts that need to align on decimal points.
  static const mono = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static const monoLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

abstract class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  // Page horizontal padding — every screen uses this
  static const pagePadding = EdgeInsets.symmetric(horizontal: 20.0);
}

abstract class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(24));
  static const full = BorderRadius.all(Radius.circular(999)); // pills
}

abstract class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',

      // ── Colour scheme ──────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.background,
        secondary: AppColors.accent,
        onSecondary: AppColors.background,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: AppColors.textPrimary,
        outline: AppColors.border,
      ),

      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ─────────────────────────────────────────────
      // Transparent by default — screens set their own title style
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.heading3,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Cards ──────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
          side: BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Filled buttons (primary actions) ───────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.buttonText,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
      ),

      // ── Outlined buttons (secondary actions) ───────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.buttonText,
          side: const BorderSide(color: AppColors.primary),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
      ),

      // ── Text buttons (tertiary / inline actions) ───────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // ── Input fields ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        labelStyle: AppTextStyles.label,
      ),

      // ── Dividers ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ── Bottom sheets ──────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
