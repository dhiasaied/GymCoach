import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'gym_coach_header.dart';

class GymCoachBottomNav extends StatelessWidget {
  const GymCoachBottomNav({super.key, this.current});

  final BottomNavKey? current;

  static const _items = [
    (key: BottomNavKey.training, icon: Icons.fitness_center, label: 'Training'),
    (key: BottomNavKey.about, icon: Icons.info, label: 'About'),
    (key: BottomNavKey.insights, icon: Icons.monitor_heart_outlined, label: 'Insights'),
    (key: BottomNavKey.coach, icon: Icons.smart_toy_outlined, label: 'Coach'),
    (key: BottomNavKey.profile, icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: AppSpacing.md,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Material(
            color: AppColors.surfaceContainer.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 50,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _items.map((item) {
                final active = item.key == current;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (active) return;
                      Navigator.of(context).pushReplacementNamed(item.key.route);
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: active
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                          size: active ? 26 : 24,
                          fill: active ? 1 : 0,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: AppTypography.labelMd(
                            color: active
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.currentNav,
    required this.body,
    this.floatingActionButton,
    this.notificationsFilled = false,
  });

  final BottomNavKey currentNav;
  final Widget body;
  final Widget? floatingActionButton;
  final bool notificationsFilled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: GymCoachHeader(notificationsFilled: notificationsFilled),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
