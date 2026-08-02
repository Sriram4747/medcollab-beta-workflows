import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/shared/presentation/widgets/clinical_card.dart';

class ContactTeamPage extends StatelessWidget {
  const ContactTeamPage({super.key});

  static const _email = 'support@vocle.app';

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBar(
        title: const Text('Contact team'),
        backgroundColor: AppColors.backgroundApp,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Text(
            'Reach the Vocle beta team for account help, clinical workflow '
            'questions, or urgent issues during the pilot.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          ClinicalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vocle beta support',
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Email us and we will get back during the pilot window.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        _email,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.tealDark,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy email',
                      onPressed: () => _copyEmail(context),
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _copyEmail(context),
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copy support email'),
          ),
        ],
      ),
    );
  }
}
