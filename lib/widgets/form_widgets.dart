import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../utils/validators.dart';

class RecessedInputField extends StatefulWidget {
  const RecessedInputField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.suffix,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Widget? suffix;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<RecessedInputField> createState() => _RecessedInputFieldState();
}

class _RecessedInputFieldState extends State<RecessedInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              widget.label!,
              style: AppTypography.labelLg(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.recessedInput,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                color: Color(0x80000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
              if (_focused)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 15,
                ),
              if (hasError)
                const BoxShadow(
                  color: AppColors.error,
                  spreadRadius: 0,
                ),
            ],
            border: Border(
              bottom: BorderSide(
                color: hasError
                    ? AppColors.error
                    : _focused
                        ? AppColors.primary
                        : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.base,
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: AppColors.onSurfaceVariant, size: 22),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Focus(
                  onFocusChange: (v) => setState(() => _focused = v),
                  child: TextField(
                    controller: widget.controller,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    textAlign: widget.textAlign,
                    onChanged: widget.onChanged,
                    style: AppTypography.bodyMd(),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: AppTypography.bodyMd(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.suffix != null) widget.suffix!,
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: AppTypography.labelMd(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = PasswordStrength.evaluate(password);
    Color barColor;
    switch (strength.colorToken) {
      case ColorToken.error:
        barColor = AppColors.error;
      case ColorToken.tertiary:
        barColor = AppColors.tertiaryContainer;
      case ColorToken.primary:
        barColor = AppColors.primary;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 300),
            widthFactor: strength.percent / 100,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          strength.label,
          style: AppTypography.labelMd(
            color: strength.colorToken == ColorToken.error
                ? AppColors.error
                : strength.colorToken == ColorToken.tertiary
                    ? AppColors.tertiaryContainer
                    : AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class PrimarySubmitButton extends StatelessWidget {
  const PrimarySubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimaryContainer,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.6),
        ),
        child: Text(
          label,
          style: AppTypography.headlineMd(color: AppColors.onPrimaryContainer),
        ),
      ),
    );
  }
}

class FormBannerError extends StatelessWidget {
  const FormBannerError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Text(
        message,
        style: AppTypography.bodyMd(color: AppColors.onErrorContainer),
      ),
    );
  }
}

class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : null,
                  borderRadius: BorderRadius.circular(999),
                  border: selected
                      ? null
                      : Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  labels[index],
                  style: AppTypography.labelLg(
                    color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
