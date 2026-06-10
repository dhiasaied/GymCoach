import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../widgets/glass_card.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static const _faqs = [
    (
      question: 'How do I start a workout?',
      answer:
          'Open the Training tab, choose a program, and tap the play button to begin immediately. You can also tap the card to view full details before starting.',
    ),
    (
      question: 'How does the AI Coach work?',
      answer:
          'The Coach tab lets you chat about your training. Ask for intensity adjustments, recovery advice, or tap "Generate Full Workout" to launch a session based on AI recommendations.',
    ),
    (
      question: 'Where can I track my progress?',
      answer:
          'The Insights tab shows muscle performance, weight trends, personal records, and your full activity history.',
    ),
    (
      question: 'How do I create a custom workout?',
      answer:
          'On the Training tab, tap the + button to define title, description, duration, and intensity. Save it or create and start immediately.',
    ),
    (
      question: 'How do I update my profile?',
      answer:
          'Go to Profile, tap Edit Profile, update your details, and save. Your weight and height help personalize AI recommendations.',
    ),
  ];

  int? _expandedIndex;

  Future<void> _showContactSheet() async {
    const email = 'support@gymcoach.com';
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Contact Support', style: AppTypography.headlineMd()),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Our team typically responds within 24 hours.',
                style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(email, style: AppTypography.labelLg()),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: email));
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email copied to clipboard.')),
                        );
                      },
                      icon: const Icon(Icons.copy, color: AppColors.primary),
                      tooltip: 'Copy email',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CLOSE'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Help & Support', style: AppTypography.headlineMd()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        children: [
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Start Guide', style: AppTypography.headlineMd()),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Browse programs on Training, chat with your AI Coach, and review analytics on Insights. Your profile stores personal metrics for smarter recommendations.',
                  style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Frequently Asked Questions', style: AppTypography.headlineMd()),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(_faqs.length, (index) {
            final faq = _faqs[index];
            final expanded = _expandedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                onTap: () => setState(() => _expandedIndex = expanded ? null : index),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(faq.question, style: AppTypography.labelLg()),
                        ),
                        Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    if (expanded) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        faq.answer,
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _showContactSheet,
            icon: const Icon(Icons.support_agent),
            label: const Text('CONTACT SUPPORT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(52),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            child: const Text('OPEN SETTINGS'),
          ),
        ],
      ),
    );
  }
}
