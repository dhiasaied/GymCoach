import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_coach_header.dart';
import '../widgets/gym_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _slide = 0;
  Timer? _autoTimer;

  static const _slides = [
    _SlideData(
      image: AssetPaths.splashAiCoach,
      title: 'Meet Your ',
      highlight: 'AI Coach',
      body:
          'Advanced biomechanics tracking and adaptive intelligence tailored to your unique physiological profile.',
      overlay: _OverlayData(
        icon: Icons.psychology,
        title: 'AI SYNCED',
        subtitle: 'Real-time Form Correction',
      ),
    ),
    _SlideData(
      image: AssetPaths.splashWorkout,
      title: 'Precision ',
      highlight: 'Training',
      body:
          'Dynamic workout architectures that evolve as you get stronger. No plateaus, just progress.',
      overlay: _OverlayData(
        icon: Icons.trending_up,
        title: '+12%',
        subtitle: 'Monthly',
        isStats: true,
      ),
    ),
    _SlideData(
      image: AssetPaths.splashPerformance,
      title: 'Beyond ',
      highlight: 'Limits',
      body:
          'Integrated recovery tracking and nutritional synthesis for the complete high-performance lifestyle.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoTimer = Timer(const Duration(seconds: 4), _navigateNext);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _navigateNext() async {
    _autoTimer?.cancel();
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final route = auth.isLoggedIn ? AppRoutes.home : AppRoutes.login;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SplashHeader(),
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.sizeOf(context).height * 0.1,
            right: -MediaQuery.sizeOf(context).width * 0.1,
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
            bottom: -MediaQuery.sizeOf(context).height * 0.1,
            left: -MediaQuery.sizeOf(context).width * 0.1,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.1),
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _slide = i),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.containerMargin,
                  AppSpacing.xl,
                  AppSpacing.containerMargin,
                  220,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GymImage(source: slide.image, fit: BoxFit.contain),
                          if (slide.overlay != null)
                            Positioned(
                              top: index == 1 ? null : 0,
                              bottom: index == 1 ? 40 : null,
                              right: index == 1 ? null : 0,
                              left: index == 1 ? 0 : null,
                              child: _FloatingOverlay(data: slide.overlay!),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTypography.displayLgMobile(),
                        children: [
                          TextSpan(text: slide.title),
                          TextSpan(
                            text: slide.highlight,
                            style: AppTypography.displayLgMobile(
                              color: AppColors.primary,
                            ).copyWith(
                              shadows: [
                                Shadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      slide.body,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: AppSpacing.containerMargin,
            right: AppSpacing.containerMargin,
            bottom: 128,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _slide;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 32 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('NEXT', style: AppTypography.headlineMd(color: AppColors.onPrimary)),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.image,
    required this.title,
    required this.highlight,
    required this.body,
    this.overlay,
  });

  final String image;
  final String title;
  final String highlight;
  final String body;
  final _OverlayData? overlay;
}

class _OverlayData {
  const _OverlayData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isStats = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isStats;
}

class _FloatingOverlay extends StatelessWidget {
  const _FloatingOverlay({required this.data});

  final _OverlayData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 12,
      child: data.isStats
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(data.icon, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.base),
                    Text('VO2 MAX', style: AppTypography.labelLg()),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.title,
                        style: AppTypography.headlineMd(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: ' ${data.subtitle}',
                        style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data.icon, color: AppColors.primary),
                Text(data.title, style: AppTypography.headlineMd(color: AppColors.primary)),
                Text(
                  data.subtitle,
                  style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
    );
  }
}
