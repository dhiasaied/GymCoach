import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/notification_model.dart';
import '../providers/notifications_provider.dart';
import '../utils/notification_navigator.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_coach_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filterIndex = 0;
  static const _filters = ['All', 'AI Coach', 'Workouts', 'System'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: const GymCoachHeader(notificationsFilled: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              88,
              AppSpacing.containerMargin,
              140,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inbox', style: AppTypography.headlineMd()),
                              Text(
                                'Stay updated with your progress',
                                style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: provider.clearAll,
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CountBubble('Total', '${provider.total}', AppColors.primary),
                          _CountBubble('Unread', '${provider.unread}', AppColors.secondary),
                          _CountBubble('Critical', '${provider.critical}', AppColors.error),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilterChipBar(
                  labels: _filters,
                  selectedIndex: _filterIndex,
                  onSelected: (i) => setState(() => _filterIndex = i),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...provider.filteredBy(_filterIndex).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.base),
                    child: _NotificationTile(
                      item: item,
                      onTap: () => handleNotificationAction(context, item),
                      onMarkRead: () => provider.markRead(item.id),
                      onDelete: () => provider.remove(item.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const GymCoachBottomNav(),
        ],
      ),
    );
  }
}

class _CountBubble extends StatelessWidget {
  const _CountBubble(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerHigh,
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          alignment: Alignment.center,
          child: Text(value, style: AppTypography.headlineMd(color: color)),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onMarkRead,
    required this.onDelete,
  });

  final NotificationModel item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        color: AppColors.errorContainer,
        child: const Icon(Icons.delete, color: AppColors.error),
      ),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: item.borderColor, width: 4),
                ),
              ),
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.iconColor.withValues(alpha: 0.1),
                    ),
                    child: Icon(item.icon, color: item.iconColor),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.title, style: AppTypography.labelLg()),
                            Text(
                              item.timeLabel,
                              style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.body,
                          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: item.isRead ? null : onMarkRead,
                          child: Text(item.isRead ? 'Read' : 'Mark read'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
