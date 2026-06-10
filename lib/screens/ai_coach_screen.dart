import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/chat_message.dart';
import '../services/ai_coach_service.dart';
import '../utils/validators.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/glass_card.dart';
import 'workout_session_screen.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _aiService = AiCoachService();
  final _messages = <ChatMessage>[
    const ChatMessage(
      text:
          "Welcome back, Athlete. I've analyzed your sleep data (7.2h) and morning heart rate. Your recovery is at 88%. Ready for a high-intensity session or should we focus on mobility today?",
      isUser: false,
    ),
    const ChatMessage(
      text:
          "Let's go for high intensity. Focus on legs and explosive power. What's the plan?",
      isUser: true,
    ),
  ];
  bool _voiceActive = false;
  bool _isReplying = false;
  String? _messageError;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? overrideText]) {
    final text = (overrideText ?? _messageController.text).trim();
    if (overrideText == null) {
      final error = Validators.chatMessage(text);
      if (error != null) {
        setState(() => _messageError = error);
        return;
      }
    }

    setState(() {
      _messageError = null;
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
      _isReplying = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: _aiService.generateReply(text), isUser: false));
        _isReplying = false;
      });
      _scrollToBottom();
    });
  }

  Future<void> _showVoiceInputSheet() async {
    setState(() => _voiceActive = true);
    final sample = await showModalBottomSheet<String>(
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
              Text('Voice Input', style: AppTypography.headlineMd()),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select a phrase to send to your AI Coach:',
                style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              ...AiCoachService.voiceSamples.map(
                (sample) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(sample),
                    child: Text(sample),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => _voiceActive = false);
    if (sample != null) {
      _sendMessage(sample);
    }
  }

  void _generateFullWorkout() {
    final workout = _aiService.generateFullWorkout();
    openWorkoutSession(context, workout);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.coach,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.containerMargin,
                    96,
                    AppSpacing.containerMargin,
                    180,
                  ),
                  children: [
                    ..._messages.map(_ChatBubble.new),
                    _WorkoutSuggestionCard(onGenerate: _generateFullWorkout),
                    if (_isReplying) const _TypingIndicator(),
                  ],
                ),
              ),
              _ChatInputBar(
                controller: _messageController,
                voiceActive: _voiceActive,
                errorText: _messageError,
                onVoiceToggle: _showVoiceInputSheet,
                onSend: () => _sendMessage(),
              ),
            ],
          ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.coach),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble(this.message);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(message.text, style: AppTypography.bodyMd(color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryContainer,
                child: const Icon(Icons.person, size: 18, color: AppColors.onPrimaryContainer),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondaryContainer,
            child: const Icon(Icons.smart_toy, size: 18, color: AppColors.onSecondaryContainer),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COACH AI', style: AppTypography.labelMd(color: AppColors.secondaryContainer)),
                  const SizedBox(height: 4),
                  Text(message.text, style: AppTypography.bodyMd()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSuggestionCard extends StatelessWidget {
  const _WorkoutSuggestionCard({required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.secondaryContainer,
          child: const Icon(Icons.smart_toy, size: 18, color: AppColors.onSecondaryContainer),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('COACH AI', style: AppTypography.labelMd(color: AppColors.secondaryContainer)),
                const SizedBox(height: 4),
                Text(
                  'Excellent choice. Based on your current fatigue levels, I recommend a Plyometric-Power Cluster. Here is the core structure:',
                  style: AppTypography.bodyMd(),
                ),
                const SizedBox(height: AppSpacing.md),
                _ExerciseTile(
                  icon: Icons.auto_mode,
                  title: 'Box Jumps (Reactive)',
                  subtitle: '4 Sets x 6 Reps',
                ),
                const SizedBox(height: AppSpacing.sm),
                _ExerciseTile(
                  icon: Icons.fitness_center,
                  title: 'Goblet Squats (Explosive)',
                  subtitle: '3 Sets x 8 Reps',
                  color: AppColors.secondary,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton.icon(
                  onPressed: onGenerate,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('GENERATE FULL WORKOUT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderRadius: 12,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLg()),
                Text(subtitle, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.3),
          child: const Icon(Icons.smart_toy, size: 16, color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.sm),
        Row(
          children: List.generate(3, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.voiceActive,
    required this.onVoiceToggle,
    required this.onSend,
    this.errorText,
  });

  final TextEditingController controller;
  final bool voiceActive;
  final VoidCallback onVoiceToggle;
  final VoidCallback onSend;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerMargin,
        AppSpacing.sm,
        AppSpacing.containerMargin,
        120,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (voiceActive)
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              borderRadius: 999,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(7, (_) => Container(
                        width: 4,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'LISTENING...',
                      style: AppTypography.labelLg(color: AppColors.primary).copyWith(letterSpacing: 3),
                    ),
                  ),
                ],
              ),
            ),
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.xs),
            borderRadius: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: onVoiceToggle,
                  icon: Icon(
                    voiceActive ? Icons.mic : Icons.mic_none,
                    color: voiceActive ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: AppTypography.bodyMd(),
                    decoration: InputDecoration(
                      hintText: 'Ask anything about your training...',
                      border: InputBorder.none,
                      errorText: errorText,
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                IconButton(
                  onPressed: onSend,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.secondaryContainer,
                    foregroundColor: AppColors.onSecondaryContainer,
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
