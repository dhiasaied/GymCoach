import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

class GymCoachHeader extends StatelessWidget implements PreferredSizeWidget {
  const GymCoachHeader({
    super.key,
    this.showLogoIcon = true,
    this.notificationsFilled = false,
    this.onNotificationsTap,
  });

  final bool showLogoIcon;
  final bool notificationsFilled;
  final VoidCallback? onNotificationsTap;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 24,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin,
              vertical: AppSpacing.base,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showLogoIcon)
                    GestureDetector(
                      onTap: () => _goHome(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer.withValues(alpha: 0.2),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 40),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _goHome(context),
                      child: Text(
                        'GYMCOACH',
                        textAlign: TextAlign.center,
                        style: AppTypography.displayLgMobile(
                          color: AppColors.primary,
                        ).copyWith(
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onNotificationsTap ??
                        () => Navigator.of(context).pushNamed(AppRoutes.notifications),
                    icon: Icon(
                      Icons.notifications,
                      color: AppColors.primary,
                      fill: notificationsFilled ? 1 : 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashHeader extends StatelessWidget implements PreferredSizeWidget {
  const SplashHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
            vertical: AppSpacing.base,
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GYMCOACH',
                  style: AppTypography.displayLgMobile(color: AppColors.primary)
                      .copyWith(
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                Text(
                  'v2.0.4',
                  style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
