import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import 'gym_image.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.surfaceContainerLowest,
                AppColors.background,
              ],
            ),
          ),
        ),
        Transform.scale(
          scale: 1.05,
          child: const GymImage(
            source: AssetPaths.gymBackground,
            fit: BoxFit.cover,
            opacity: 0.55,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background.withValues(alpha: 0.55),
                AppColors.background.withValues(alpha: 0.25),
                AppColors.background.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        Positioned(
          top: -size.height * 0.1,
          right: -size.width * 0.1,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -size.height * 0.1,
          left: -size.width * 0.1,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.05),
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'GYMCOACH',
          style: AppTypography.displayLgMobile(color: AppColors.primary).copyWith(
            shadows: [
              Shadow(
                color: AppColors.primary.withValues(alpha: 0.5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Elevate Your Peak',
          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant).copyWith(
            letterSpacing: 4,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
