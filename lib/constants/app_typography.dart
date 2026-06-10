import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextStyle displayLgMobile({Color? color}) => GoogleFonts.montserrat(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 32,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle displayLg({Color? color}) => GoogleFonts.montserrat(
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 48,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle headlineLg({Color? color}) => GoogleFonts.montserrat(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle headlineMd({Color? color}) => GoogleFonts.montserrat(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle bodyLg({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle bodyMd({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle labelLg({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05 * 14,
        color: color ?? AppColors.onSurface,
      );

  static TextStyle labelMd({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.onSurface,
      );
}
