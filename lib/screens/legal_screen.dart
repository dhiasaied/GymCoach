import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../widgets/glass_card.dart';

enum LegalDocumentType { terms, privacy }

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.type});

  final LegalDocumentType type;

  String get _title =>
      type == LegalDocumentType.terms ? 'Terms of Service' : 'Privacy Policy';

  String get _content {
    if (type == LegalDocumentType.terms) {
      return '''
Welcome to GYMCOACH. By using this application, you agree to train responsibly and follow professional guidance when needed.

1. Account Usage
You are responsible for maintaining the confidentiality of your credentials and for all activity under your account.

2. Health Disclaimer
GYMCOACH provides fitness guidance, not medical advice. Consult a physician before starting any exercise program.

3. Acceptable Use
You agree not to misuse the platform, attempt unauthorized access, or interfere with service operations.

4. Content
Workout plans and AI recommendations are provided for personal use. Redistribution without permission is prohibited.

5. Changes
We may update these terms. Continued use after updates constitutes acceptance of the revised terms.

6. Contact
For questions about these terms, contact support@gymcoach.com.
''';
    }
    return '''
GYMCOACH respects your privacy. This policy explains how we handle your information.

1. Information We Collect
We store account details (name, email), profile metrics (weight, height), workout history, and app preferences locally on your device.

2. How We Use Data
Your data powers personalized workout recommendations, progress tracking, and AI coaching features.

3. Data Storage
Profile and workout data are stored locally via SharedPreferences. Social login creates a dedicated account record on device.

4. Third Parties
Network images may be loaded from external CDNs. We do not sell your personal data.

5. Your Rights
You can update your profile in-app or sign out to clear your session state.

6. Contact
Privacy inquiries: privacy@gymcoach.com.
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_title, style: AppTypography.headlineMd()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            _content.trim(),
            style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

void openLegalDocument(BuildContext context, LegalDocumentType type) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => LegalScreen(type: type),
    ),
  );
}
