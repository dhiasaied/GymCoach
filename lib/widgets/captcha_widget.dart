import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'form_widgets.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../utils/captcha_helper.dart';

class CaptchaWidget extends StatefulWidget {
  const CaptchaWidget({
    super.key,
    required this.onCodeChanged,
    this.errorText,
  });

  final ValueChanged<String> onCodeChanged;
  final String? errorText;

  @override
  State<CaptchaWidget> createState() => CaptchaWidgetState();
}

class CaptchaWidgetState extends State<CaptchaWidget> {
  bool _verified = false;
  late String _code;
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void refresh() => _refresh();

  bool get isVerified => _verified;
  String get expectedCode => _code;
  String get inputValue => _inputController.text;

  void _refresh() {
    setState(() {
      _code = CaptchaHelper.generate();
      _inputController.clear();
    });
    widget.onCodeChanged(_code);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recessedInput,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _verified = !_verified),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: _verified,
                    onChanged: (v) => setState(() => _verified = v ?? false),
                    activeColor: AppColors.primaryContainer,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.verified_user, color: AppColors.onSurfaceVariant, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  "I'm not a robot",
                  style: AppTypography.labelLg(),
                ),
              ],
            ),
          ),
          if (_verified) ...[
            const Divider(color: Color(0x1AFFFFFF), height: AppSpacing.md),
            Text(
              'Enter the code (A–Z, a–z, 0–9):',
              style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    decoration: BoxDecoration(
                      color: AppColors.recessedInput,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _code.split('').map((char) {
                          Color color;
                          switch (CaptchaHelper.colorFor(char)) {
                            case ColorForChar.primary:
                              color = AppColors.primary;
                            case ColorForChar.tertiary:
                              color = AppColors.tertiary;
                            case ColorForChar.secondary:
                              color = AppColors.secondary;
                          }
                          return Transform.rotate(
                            angle: CaptchaHelper.rotationFor(char) * 3.14159 / 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                char,
                                style: AppTypography.headlineMd(color: color).copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            RecessedInputField(
              controller: _inputController,
              hint: 'Code',
              textAlign: TextAlign.center,
              errorText: widget.errorText,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }
}
