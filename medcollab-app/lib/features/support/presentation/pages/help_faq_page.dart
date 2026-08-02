import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  static const _faqs = [
    (
      'How to join a space',
      'Ask a colleague for an invite code, then open Groups → Join with code, '
          'or open a join link from them. Once joined, subgroups and handoffs '
          'for that team appear in Messages and Home.',
    ),
    (
      'Start a direct message',
      'Open Messages → Direct → New message, or use Quick actions on Home. '
          'Pick a colleague who shares a group with you to open a private DM.',
    ),
    (
      'Handoffs',
      'Handoffs capture shift-to-shift patient context. From Home or the '
          'Handoffs tab, create or open a handoff, set priority, and acknowledge '
          'when you take over. They stay visible until resolved.',
    ),
    (
      'Notifications',
      'Alerts for mentions, handoffs, and messages appear under Alerts. '
          'Tune what you receive in Profile → Notification settings. On Android, '
          'enable Vocle notifications in system settings for push delivery.',
    ),
    (
      'Availability',
      'Set Available, On call, In OT, or Off duty from Profile. Colleagues '
          'see your status so they know who to reach during a busy shift.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        backgroundColor: AppColors.backgroundApp,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            'Quick answers for Vocle beta',
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          ..._faqs.map(
            (faq) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _FaqTile(question: faq.$1, answer: faq.$2),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: AppColors.tealPrimary,
          collapsedIconColor: AppColors.textMuted,
          title: Text(question, style: AppTextStyles.cardTitle),
          children: [
            Text(
              answer,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
