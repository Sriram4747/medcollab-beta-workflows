import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({
    required this.title,
    required this.body,
    required this.lastUpdated,
    super.key,
  });

  final String title;
  final String body;
  final String lastUpdated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.backgroundApp,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            'Last updated $lastUpdated',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          SelectableText(
            body.trim(),
            style: AppTextStyles.body.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
