import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../providers/analytics_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class ProgressAnalyticsScreen extends StatelessWidget {
  const ProgressAnalyticsScreen({super.key});

  static const _periods = ['7 Days', '30 Days', '6 Months'];

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final data = analytics.currentData;

    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.insights,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              88,
              AppSpacing.containerMargin,
              140,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Hub',
                  style: AppTypography.labelLg(color: AppColors.primary).copyWith(letterSpacing: 3),
                ),
                Text('Progress Analytics', style: AppTypography.headlineLg()),
                const SizedBox(height: AppSpacing.md),
                FilterChipBar(
                  labels: _periods,
                  selectedIndex: analytics.periodIndex,
                  onSelected: analytics.setPeriodIndex,
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Muscle Performance', style: AppTypography.headlineMd()),
                      Text(
                        'Overall output vs. target — ${data.label}',
                        style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 128,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: data.muscleBars
                              .map(
                                (h) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: FractionallySizedBox(
                                      heightFactor: h,
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: h >= 0.85
                                              ? AppColors.primary
                                              : AppColors.primaryContainer,
                                          borderRadius:
                                              const BorderRadius.vertical(top: Radius.circular(8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weight', style: AppTypography.headlineMd()),
                            Text(
                              data.weightChange,
                              style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data.weightValue,
                                    style: AppTypography.displayLg(color: AppColors.primary),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                                    child: Text(
                                      'kg',
                                      style:
                                          AppTypography.labelLg(color: AppColors.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Records', style: AppTypography.headlineMd()),
                            ...data.records.map((r) => _RecordRow(r.$1, r.$2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Transformation Spotlight',
                          style: AppTypography.labelMd(color: AppColors.onSecondaryContainer),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Body Composition Shift', style: AppTypography.headlineLg()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        "You've successfully decreased body fat by 4.2% while increasing lean muscle mass by 1.8kg over the last 90 days.",
                        style: AppTypography.bodyLg(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GymImage(
                                  source:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBTpucOlTgL8VG87GVaUPun4mNBezDJCy3NKhAOINCB9GPMTYsfYGA-prcYTzuLsmTXDgbmr2yYK4rmZy716wEkk8Bufmd9bVo2Jagrrc9vVN5ZYAeZQFCTGjpn5rhM1iC5Ca3uMvViCHtw1T4Vuot-PT5wl9e-wU3BHdpumr3qS-qLOcBgwKCxJ3nTAFdGD7Dcqd93Vtk6S27Q7XHIxiaF9xssA67aG1zTUM8tM1HxVSdb67L6hmQE1DQ7xjgKY-F2STzxT6n8BnE',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GymImage(
                                  source: AssetPaths.profileAvatar,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.activityHistory),
                          child: const Text('VIEW FULL ACTIVITY HISTORY'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.insights),
      ],
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTypography.labelLg(color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
