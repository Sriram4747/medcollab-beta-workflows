import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  static const _faqs = [
    (
      'How do I join a group?',
      'Ask a colleague for an invite code or QR. Open Groups → Join with code, '
          'or Profile / Home → Scan invite QR. Once joined, subgroups and handoffs '
          'for that team appear in Messages and Home.',
    ),
    (
      'How do I start a direct message?',
      'Open Messages → Direct → New message, or use Quick actions on Home. '
          'You can only DM doctors you share a group with, already chat with, '
          'or who are at the same institution.',
    ),
    (
      'What are handoffs?',
      'Handoffs capture shift-to-shift patient context. From Home or the '
          'Handoffs tab, create or open a handoff, set priority, and acknowledge '
          'when you take over. They stay visible until resolved. Do not paste '
          'full identifiers unless your hospital policy allows it.',
    ),
    (
      'How do notifications work?',
      'Alerts for mentions, handoffs, and messages appear under Alerts. '
          'Tune categories in Profile → Notification settings. On Android, '
          'allow Vocle notifications in system settings. You will not get a '
          'banner for a chat you currently have open.',
    ),
    (
      'OTP and sign-in',
      'Sign in with your Indian mobile number. We send a 6-digit OTP via MSG91. '
          'OTP is valid for a few minutes. Never share it. Contact vocle.official@gmail.com '
          'if you cannot receive SMS.',
    ),
    (
      'Privacy and patient information',
      'Vocle is a closed beta for invited doctors. We do not sell data or use '
          'ad/analytics SDKs. You are responsible for hospital policy when typing '
          'or attaching clinical details. Read Privacy Policy and Terms from Profile '
          'or the sign-in screen.',
    ),
    (
      'How do I report a bug or send feedback?',
      'Profile → Report a bug, Send feedback, or Feature request. Urgent issues: '
          'email vocle.official@gmail.com. Do not include patient names in tickets.',
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
